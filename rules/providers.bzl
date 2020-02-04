ScalaConfiguration = provider(
    doc = "Scala compile-time and runtime configuration",
    fields = {
        "version": "The Scala full version.",
        "compiler_classpath": "The compiler classpath.",
        "runtime_classpath": "The runtime classpath.",
        "global_plugins": "Globally enabled compiler plugins",
        "global_scalacopts": "Globally enabled compiler options",
    },
)

ScalaInfo = provider(
    doc = "Scala library.",
    fields = {
        "macro": "whether the jar contains macros",
        "scala_configuration": "ScalaConfiguration associated with this output",
    },
)

ZincConfiguration = provider(
    doc = "Zinc configuration.",
    fields = {
        "compiler_bridge": "compiled Zinc compiler bridge",
        "compile_worker": "the worker label for compilation with Zinc",
        "log_level": "log level for the Zinc compiler",
    },
)

ZincInfo = provider(
    doc = "Zinc-specific outputs.",
    fields = {
        "apis": "The API file.",
        "deps": "The depset of library dependency outputs.",
        "deps_files": "The depset of all Zinc files.",
        "label": "The label for this output.",
        "relations": "The relations file.",
    },
)
