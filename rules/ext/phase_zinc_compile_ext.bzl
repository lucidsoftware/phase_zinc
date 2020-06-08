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

def _zinc_compile_singleton_implementation(ctx):
    return [
        _ScalaRulePhase(
            custom_phases = [
                ("=", "compile", "compile", _phase_zinc_compile),
            ],
        ),
    ]

zinc_compile_singleton = rule(
    implementation = _zinc_compile_singleton_implementation,
)
