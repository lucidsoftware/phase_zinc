###
# Scala source files in this directory borrowed from https://github.com/higherkindness/rules_scala/tree/b772564a20eee9271068cfba55147191385343bd/src/main/scala/higherkindness/rules_scala/workers/zinc/compile
###

load("@io_bazel_rules_scala//scala:scala.bzl", "scala_binary")

# Zinc compile runner.
scala_binary(
    name = "workers",
    srcs = glob(["*.scala"]),
    main_class = "phase_zinc.workers.ZincRunner",
    visibility = ["//visibility:public"],
    runtime_deps = [
        "@zinc//:com_lihaoyi_sourcecode_2_12",
    ],
    deps = [
        "//src/main/scala/common/jarhelper",
        "//src/main/scala/common/logger",
        "@io_bazel_rules_scala//src/java/io/bazel/rulesscala/worker",
        "@zinc//:com_google_protobuf_protobuf_java",
        "@zinc//:com_trueaccord_lenses_lenses_2_12",
        "@zinc//:com_trueaccord_scalapb_scalapb_runtime_2_12",
        "@zinc//:net_sourceforge_argparse4j_argparse4j",
        "@zinc//:org_scala_sbt_compiler_interface",
        "@zinc//:org_scala_sbt_io_2_12",
        "@zinc//:org_scala_sbt_test_interface",
        "@zinc//:org_scala_sbt_util_control_2_12",
        "@zinc//:org_scala_sbt_util_interface",
        "@zinc//:org_scala_sbt_zinc_2_12",
        "@zinc//:org_scala_sbt_zinc_classpath_2_12",
        "@zinc//:org_scala_sbt_zinc_compile_core_2_12",
        "@zinc//:org_scala_sbt_zinc_core_2_12",
        "@zinc//:org_scala_sbt_zinc_persist_2_12",
    ],
)
