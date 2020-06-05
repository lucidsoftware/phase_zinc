#
# PHASE: phase zinc
#
# Zinc compiler
#
load(
    "@bazel_tools//tools/jdk:toolchain_utils.bzl",
    "find_java_runtime_toolchain",
    "find_java_toolchain",
)
load(
    "@io_bazel_rules_scala//scala/private:paths.bzl",
    "get_files_with_extension",
    "java_extension",
    "scala_extension",
    "srcjar_extension",
)
load(
    "@phase_zinc//rules:providers.bzl",
    _ScalaConfiguration = "ScalaConfiguration",
    _ScalaInfo = "ScalaInfo",
    _ZincConfiguration = "ZincConfiguration",
    _ZincInfo = "ZincInfo",
)

# This function provides the logic for the Zinc compiler phase
def phase_zinc_compile(ctx, p):
    scala_configuration = ctx.attr.scala[_ScalaConfiguration]
    zinc_configuration = ctx.attr.scala[_ZincConfiguration]

    label_path = "zinc/" + ctx.label.name
    apis = ctx.actions.declare_file("{}/apis.gz".format(label_path))
    infos = ctx.actions.declare_file("{}/infos.gz".format(label_path))
    mains_file = ctx.actions.declare_file("{}.jar.mains.txt".format(label_path))
    relations = ctx.actions.declare_file("{}/relations.gz".format(label_path))
    setup = ctx.actions.declare_file("{}/setup.gz".format(label_path))
    stamps = ctx.actions.declare_file("{}/stamps.gz".format(label_path))
    used = ctx.actions.declare_file("{}/deps_used.txt".format(label_path))
    class_jar = ctx.actions.declare_file("{}/classes.jar".format(label_path))

    tmp = ctx.actions.declare_directory("{}/tmp".format(label_path))

    javacopts = [
        ctx.expand_location(option, ctx.attr.data)
        for option in ctx.attr.javacopts + java_common.default_javac_opts(
            java_toolchain = find_java_toolchain(ctx, ctx.attr._java_toolchain),
        )
    ]

    zincs = [dep[_ZincInfo] for dep in ctx.attr.deps if _ZincInfo in dep]

    compiler_classpath, compile_classpath, plugin_classpath = _classpaths(ctx, scala_configuration)

    srcs = get_files_with_extension(ctx, java_extension) + get_files_with_extension(ctx, scala_extension)
    src_jars = get_files_with_extension(ctx, srcjar_extension)

    args = ctx.actions.args()
    args.add_all(depset(transitive = [zinc.deps for zinc in zincs]), map_each = _compile_analysis)
    args.add("--compiler_bridge", zinc_configuration.compiler_bridge)
    args.add_all("--compiler_classpath", compiler_classpath)
    args.add_all("--classpath", compile_classpath)
    args.add_all(scala_configuration.global_scalacopts, format_each = "--compiler_option=%s")
    args.add_all(ctx.attr.scalacopts, format_each = "--compiler_option=%s")
    args.add_all(javacopts, format_each = "--java_compiler_option=%s")
    args.add(ctx.label, format = "--label=%s")
    args.add("--main_manifest", mains_file)
    args.add("--output_apis", apis)
    args.add("--output_infos", infos)
    args.add("--output_jar", class_jar)
    args.add("--output_relations", relations)
    args.add("--output_setup", setup)
    args.add("--output_stamps", stamps)
    args.add("--output_used", used)
    args.add_all("--plugins", plugin_classpath)
    args.add_all("--source_jars", src_jars)
    args.add("--tmp", tmp.path)
    args.add("--log_level", zinc_configuration.log_level)
    args.add_all("--", srcs)
    args.set_param_file_format("multiline")
    args.use_param_file("@%s", use_always = True)

    worker = zinc_configuration.compile_worker

    worker_inputs, _, input_manifests = ctx.resolve_command(tools = [worker])
    inputs = depset(
        [zinc_configuration.compiler_bridge] + ctx.files.data + ctx.files.srcs + worker_inputs,
        transitive = [
            plugin_classpath,
            compile_classpath,
            compiler_classpath,
        ] + [zinc.deps_files for zinc in zincs],
    )

    outputs = [class_jar, mains_file, apis, infos, relations, setup, stamps, used, tmp]

    # todo: different execution path for nosrc jar?
    ctx.actions.run(
        mnemonic = "ScalaZinc",
        inputs = inputs,
        outputs = outputs,
        executable = worker.files_to_run.executable,
        input_manifests = input_manifests,
        execution_requirements = {"supports-workers": "1"},
        arguments = [args],
    )

    java_info = _javainfo(ctx, scala_configuration)

    jars = []
    for jar in java_info.outputs.jars:
        jars.append(jar.class_jar)
        jars.append(jar.ijar)
    zinc_info = _ZincInfo(
        apis = apis,
        deps_files = depset([apis, relations], transitive = [zinc.deps_files for zinc in zincs]),
        label = ctx.label,
        relations = relations,
        deps = depset(
            [struct(
                apis = apis,
                jars = tuple(jars),
                label = ctx.label,
                relations = relations,
            )],
            transitive = [zinc.deps for zinc in zincs],
        ),
    )

    # TODO: fix this hack
    temp_statsfile = ctx.actions.declare_file("{}.statsfile".format(ctx.label.name))
    ctx.actions.run_shell(
        outputs = [temp_statsfile],
        command = "echo statefile > '%s'" % (temp_statsfile.path),
    )

    inputs = [f for f in ctx.files.resource_jars if f.extension.lower() in ["jar"]]
    phantom_inputs = []
    for v in [getattr(p, k) for k in dir(p) if k not in ["to_json", "to_proto"]]:
        if hasattr(v, "jar"):
            jar = getattr(v, "jar")
            inputs.append(jar)
        if hasattr(v, "outputs"):
            phantom_inputs.extend(getattr(v, "outputs"))
    inputs.append(class_jar)

    _action_singlejar(ctx, inputs, ctx.outputs.jar, phantom_inputs)

    return struct(
        mains_file = mains_file,
        files = depset([ctx.outputs.jar]),
        # TODO: fix this hack
        rjars = depset([ctx.outputs.jar], transitive = [p.collect_jars.transitive_runtime_jars]),
        used = used,
        external_providers = {
            "ZincInfo": zinc_info,
            "JavaInfo": java_info,
        },
    )

def _compile_analysis(analysis):
    return [
        "--analysis",
        "_{}".format(analysis.label),
        analysis.apis.path,
        analysis.relations.path,
    ] + [jar.path for jar in analysis.jars]

def _classpaths(ctx, scala_configuration):
    # compiler_classpath
    compiler_classpath = java_common.merge(
        _collect(JavaInfo, scala_configuration.compiler_classpath),
    ).transitive_runtime_jars

    # compile_classpath
    macro_classpath = [
        dep[JavaInfo].transitive_runtime_jars
        for dep in ctx.attr.deps
        if _ScalaInfo in dep and dep[_ScalaInfo].macro
    ]
    scalatest = [ctx.attr._scalatest] if hasattr(ctx.attr, "_scalatest") else []
    sdeps = java_common.merge(
        _collect(JavaInfo, scala_configuration.runtime_classpath + ctx.attr.deps + scalatest),
    )

    compile_classpath = depset(
        order = "preorder",
        transitive = macro_classpath + [sdeps.transitive_compile_time_jars],
    )

    # plugin_classpath
    plugin_skip_jars = java_common.merge(
        _collect(JavaInfo, scala_configuration.compiler_classpath +
                           scala_configuration.runtime_classpath),
    ).transitive_runtime_jars.to_list()

    actual_plugins = []
    for plugin in ctx.attr.plugins + scala_configuration.global_plugins:
        deps = [dep for dep in plugin[JavaInfo].transitive_runtime_jars.to_list() if dep not in plugin_skip_jars]
        if len(deps) == 1:
            actual_plugins.extend(deps)
        else:
            # scalac expects each plugin to be fully isolated, so we need to
            # smash everything together with singlejar
            print("WARNING! " +
                  "It is slightly inefficient to use a JVM target with " +
                  "dependencies directly as a scalac plugin. Please " +
                  "SingleJar the target before using it as a scalac plugin " +
                  "in order to avoid additional overhead.")

            plugin_singlejar = ctx.actions.declare_file(
                "{}/scalac_plugin_{}.jar".format(ctx.label.name, plugin.label.name),
            )
            _action_singlejar(
                ctx,
                inputs = deps,
                output = plugin_singlejar,
                progress_message = "singlejar scalac plugin %s" % plugin.label.name,
            )
            actual_plugins.append(plugin_singlejar)

    plugin_classpath = depset(actual_plugins)

    return compiler_classpath, compile_classpath, plugin_classpath

def _javainfo(ctx, scala_configuration):
    sruntime_deps = java_common.merge(_collect(JavaInfo, ctx.attr.runtime_deps))
    sexports = java_common.merge(_collect(JavaInfo, getattr(ctx.attr, "exports", [])))
    scala_configuration_runtime_deps = _collect(JavaInfo, scala_configuration.runtime_classpath)
    sdeps = java_common.merge(
        _collect(JavaInfo, scala_configuration.runtime_classpath + ctx.attr.deps),
    )

    if len(ctx.attr.srcs) == 0 and len(ctx.attr.resources) == 0:
        java_info = java_common.merge([sdeps, sexports])
    else:
        compile_jar = java_common.run_ijar(
            ctx.actions,
            jar = ctx.outputs.jar,
            target_label = ctx.label,
            java_toolchain = find_java_toolchain(ctx, ctx.attr._java_toolchain),
        )

        source_jar = java_common.pack_sources(
            ctx.actions,
            output_jar = ctx.outputs.jar,
            sources = ctx.files.srcs,
            host_javabase = find_java_runtime_toolchain(ctx, ctx.attr._host_javabase),
            java_toolchain = find_java_toolchain(ctx, ctx.attr._java_toolchain),
        )

        java_info = JavaInfo(
            compile_jar = compile_jar,
            neverlink = getattr(ctx.attr, "neverlink", False),
            output_jar = ctx.outputs.jar,
            source_jar = source_jar,
            exports = [sexports],
            runtime_deps = [sruntime_deps] + scala_configuration_runtime_deps,
            deps = [sdeps],
        )

    return java_info

def _collect(index, iterable):
    return [entry[index] for entry in iterable]

def _action_singlejar(
        ctx,
        inputs,
        output,
        phantom_inputs = depset(),
        main_class = None,
        progress_message = None,
        resources = {}):
    # This calls bazels singlejar utility.
    # For a full list of available command line options see:
    # https://github.com/bazelbuild/bazel/blob/master/src/java_tools/singlejar/java/com/google/devtools/build/singlejar/SingleJar.java#L311
    # The C++ version is being used now, which does not support workers. This is why workers are disabled for SingleJar

    if type(inputs) == "list":
        inputs = depset(inputs)
    if type(phantom_inputs) == "list":
        phantom_inputs = depset(phantom_inputs)

    args = ctx.actions.args()
    args.add("--exclude_build_data")
    args.add("--normalize")
    args.add_all("--sources", inputs)
    args.add_all("--resources", ["{}:{}".format(value.path, key) for key, value in resources.items()])
    args.add("--output", output)
    if main_class != None:
        args.add("--main_class", main_class)
        args.set_param_file_format("multiline")
        args.use_param_file("@%s", use_always = True)

    all_inputs = depset(resources.values(), transitive = [inputs, phantom_inputs])

    ctx.actions.run(
        arguments = [args],
        executable = ctx.executable._singlejar,
        execution_requirements = {"supports-workers": "0"},
        mnemonic = "SingleJar",
        inputs = all_inputs,
        outputs = [output],
        progress_message = progress_message,
    )
