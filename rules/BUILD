load(
    "@phase_zinc//rules:scala.bzl",
    "configure_zinc_scala",
    "scala_library",
)

scala_version = "2.12.8"

compiler_classpath = [
    "@zinc//:org_scala_lang_scala_compiler",
    "@zinc//:org_scala_lang_scala_library",
    "@zinc//:org_scala_lang_scala_reflect",
]

runtime_classpath = [
    "@zinc//:org_scala_lang_scala_library",
]

scala_library(
    name = "compiler_bridge",
    srcs = [
        "@compiler_bridge_2_12//:src",
    ],
    visibility = ["//visibility:public"],
    deps = compiler_classpath + [
        "@zinc//:org_scala_sbt_compiler_interface",
        "@zinc//:org_scala_sbt_util_interface",
    ],
)

# Load values into ScalaConfiguration and ZincConfiguration, which are later passed into phase_zinc_compile
configure_zinc_scala(
    name = "zinc",
    compiler_bridge = ":compiler_bridge",
    compiler_classpath = compiler_classpath,
    global_scalacopts = ["-nowarn"],
    runtime_classpath = runtime_classpath,
    version = scala_version,
    visibility = ["//visibility:public"],
)
