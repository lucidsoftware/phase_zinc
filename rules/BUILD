load("@phase_zinc//rules:scala.bzl", "scala_library")
load(
    "@phase_zinc//rules:scala.bzl",
    "configure_bootstrap_scala",
)

scala_version = "2.12.10"

compiler_classpath = [
    "@maven//:org_scala_lang_scala_compiler",
    "@maven//:org_scala_lang_scala_library",
    "@maven//:org_scala_lang_scala_reflect",
]

runtime_classpath = [
    "@maven//:org_scala_lang_scala_library",
]

configure_bootstrap_scala(
    name = "bootstrap",
    compiler_classpath = compiler_classpath,
    runtime_classpath = runtime_classpath,
    version = scala_version,
    visibility = ["//visibility:public"],
)

scala_library(
    name = "compiler_bridge",
    srcs = [
        "@compiler_bridge_2_12//:src",
    ],
    scala = ":bootstrap",
    visibility = ["//visibility:public"],
    deps = compiler_classpath + [
        "@maven//:org_scala_sbt_compiler_interface",
        "@maven//:org_scala_sbt_util_interface",
    ],
)
