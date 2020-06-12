###
# Borrowed from https://github.com/higherkindness/rules_scala/blob/b772564a20eee9271068cfba55147191385343bd/src/main/scala/higherkindness/rules_scala/common/args/BUILD
###

load("@io_bazel_rules_scala//scala:scala.bzl", "scala_library")

scala_library(
    name = "args",
    srcs = glob(["*.scala"]),
    visibility = ["//visibility:public"],
    deps = [
        "@zinc//:net_sourceforge_argparse4j_argparse4j",
    ],
)
