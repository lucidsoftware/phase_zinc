# make_scala_binary, etc are customizable rule macros. We can add or modify the definitions by adding/swapping phases
load(
    "@io_bazel_rules_scala//scala:advanced_usage/scala.bzl",
    _make_scala_binary = "make_scala_binary",
    _make_scala_library = "make_scala_library",
    _make_scala_test = "make_scala_test",
)

# ScalaRulePhase lets us provide phases to the customizable rules
load(
    "@io_bazel_rules_scala//scala:advanced_usage/providers.bzl",
    _ScalaRulePhase = "ScalaRulePhase",
)
load(
    "@phase_zinc//rules:providers.bzl",
    _ScalaConfiguration = "ScalaConfiguration",
    _ZincConfiguration = "ZincConfiguration",
    _ZincInfo = "ZincInfo",
)
# ext_zinc_compile is a dictionary that could contain up to 3 keys: "attrs", "outputs", and "phase_providers".
# Each of these 3 items will be passed to the rule definition when the make_scala_binary function is called.
load(
    "@phase_zinc//rules/ext:phase_zinc_compile_ext.bzl",
    _ext_zinc_compile = "ext_zinc_compile",
)

# These lines create custom versions of rules (eg. a custom scala_binary rule named "zinc_scala_binary").
# In this case, by passing in _ext_zinc_compile, the rule macro replaces the
#  normal compiler with the Zinc compiler. "attrs" and "outputs" are also passed to the rule.

# These rules have the Zinc compiler
zinc_scala_binary = _make_scala_binary(_ext_zinc_compile)
zinc_scala_library = _make_scala_library(_ext_zinc_compile)
zinc_scala_test = _make_scala_test(_ext_zinc_compile)

#  These rules are the default versions, without Zinc compiler
scala_binary = _make_scala_binary()
scala_library = _make_scala_library()
scala_test = _make_scala_test()

def _configure_bootstrap_scala_implementation(ctx):
    return [
        _ScalaConfiguration(
            compiler_classpath = ctx.attr.compiler_classpath,
            global_plugins = ctx.attr.global_plugins,
            global_scalacopts = ctx.attr.global_scalacopts,
            runtime_classpath = ctx.attr.runtime_classpath,
            version = ctx.attr.version,
        ),
    ]

configure_bootstrap_scala = rule(
    attrs = {
        "version": attr.string(mandatory = True),
        "compiler_classpath": attr.label_list(
            mandatory = True,
            providers = [JavaInfo],
        ),
        "runtime_classpath": attr.label_list(
            mandatory = True,
            providers = [JavaInfo],
        ),
        "global_plugins": attr.label_list(
            doc = "Scalac plugins that will always be enabled.",
            providers = [JavaInfo],
        ),
        "global_scalacopts": attr.string_list(
            doc = "Scalac options that will always be enabled.",
        ),
    },
    implementation = _configure_bootstrap_scala_implementation,
)

# This rule/implementation load values into ScalaConfiguration and ZincConfiguration, which are later passed into phase_zinc_compile
def _configure_zinc_scala_implementation(ctx):
    return [
        _ScalaConfiguration(
            compiler_classpath = ctx.attr.compiler_classpath,
            global_plugins = ctx.attr.global_plugins,
            global_scalacopts = ctx.attr.global_scalacopts,
            runtime_classpath = ctx.attr.runtime_classpath,
            version = ctx.attr.version,
        ),
        _ZincConfiguration(
            compile_worker = ctx.attr._compile_worker,
            compiler_bridge = ctx.file.compiler_bridge,
            log_level = ctx.attr.log_level,
        ),
    ]

configure_zinc_scala = rule(
    attrs = {
        "version": attr.string(mandatory = True),
        "runtime_classpath": attr.label_list(
            mandatory = True,
            providers = [JavaInfo],
        ),
        "compiler_classpath": attr.label_list(
            mandatory = True,
            providers = [JavaInfo],
        ),
        "compiler_bridge": attr.label(
            allow_single_file = True,
            mandatory = True,
        ),
        "global_plugins": attr.label_list(
            doc = "Scalac plugins that will always be enabled.",
            providers = [JavaInfo],
        ),
        "global_scalacopts": attr.string_list(
            doc = "Scalac options that will always be enabled.",
        ),
        "log_level": attr.string(
            doc = "Compiler log level",
            default = "warn",
        ),
        "_compile_worker": attr.label(
            default = "@phase_zinc//src/main/scala/workers",
            allow_files = True,
            executable = True,
            cfg = "host",
        ),
    },
    implementation = _configure_zinc_scala_implementation,
)
