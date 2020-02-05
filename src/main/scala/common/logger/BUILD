load("@io_bazel_rules_scala//scala:scala.bzl", "scala_library")

scala_library(
    name = "logger",
    srcs = glob(["*.scala"]),
    visibility = ["//visibility:public"],
    deps = [
        "//src/main/scala/common/args",
        "@zinc//:net_sourceforge_argparse4j_argparse4j",
        "@zinc//:org_scala_sbt_compiler_interface",
        "@zinc//:org_scala_sbt_util_interface",
        "@zinc//:org_scala_sbt_zinc_compile_core_2_12",
    ],
)
