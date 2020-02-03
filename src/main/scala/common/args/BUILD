load("@io_bazel_rules_scala//scala:scala.bzl", "scala_library")

scala_library(
    name = "args",
    srcs = glob(["*.scala"]),
    visibility = ["//visibility:public"],
    deps = [
        "@maven//:net_sourceforge_argparse4j_argparse4j",
    ],
)
