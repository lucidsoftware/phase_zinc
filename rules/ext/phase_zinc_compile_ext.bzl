load(
    "@io_bazel_rules_scala//scala:advanced_usage/providers.bzl",
    _ScalaRulePhase = "ScalaRulePhase",
)
load(
    "@phase_zinc//rules:phases/phase_zinc_compile.bzl",
    _phase_zinc_compile = "phase_zinc_compile",
)
load(
    "@phase_zinc//rules:providers.bzl",
    _ScalaConfiguration = "ScalaConfiguration",
    _ZincConfiguration = "ZincConfiguration",
)

# This is a dictionary containing the phase to be inserted.
# It also adds a "scala" attribute which ensures a ScalaConfiguration provider is
#  available to the phase logic in //rules/phases/phase_zinc_compile.bzl

# In //rules/scala.bzl, ext_zinc_compile is used to make custom variants of rules (scala_binary --> zinc_scala_binary, etc)
ext_zinc_compile = {
    "attrs": {
        "scala": attr.label(
            default = "//external:default_scala",
            doc = "The `ScalaConfiguration`. Among other things, this specifies which scala version to use.\n Defaults to the default_scala target specified in the WORKSPACE file.\n Also includes ZincConfiguration data.",
            providers = [
                _ScalaConfiguration,
                _ZincConfiguration,
            ],
        ),
    },
    "phase_providers": [
        "@phase_zinc//rules/ext:phase_zinc_compile",
    ],
}

# When built, this rule creates a phase in the format that maker functions are expecting
def _zinc_compile_singleton_implementation(ctx):
    return [
        _ScalaRulePhase(
            # When the maker_scala_binary (or similar) function runs, it will assign the label "compile" to _phase_zinc_compile
            #  and insert it in the place where the previous phase labeled "compile" was.
            # Essentially, this replaces the old compiler with our Zinc compiler.
            custom_phases = [
                ("=", "compile", "compile", _phase_zinc_compile),
            ],
        ),
    ]

zinc_compile_singleton = rule(
    implementation = _zinc_compile_singleton_implementation,
)
