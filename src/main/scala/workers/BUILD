load("@io_bazel_rules_scala//scala:scala.bzl", "scala_binary")

scala_binary(
    name = "workers",
    srcs = glob(["**/*.scala"]),
    main_class = "phase_zinc.workers.ZincRunner",
    visibility = ["//visibility:public"],
    runtime_deps = [
        "@maven//:com_lihaoyi_sourcecode_2_12",
    ],
    deps = [
        "//src/main/scala/common/jarhelper",
        "//src/main/scala/common/logger",
        "@io_bazel_rules_scala//src/java/io/bazel/rulesscala/worker",
        "@maven//:com_google_protobuf_protobuf_java",
        "@maven//:com_trueaccord_lenses_lenses_2_12",
        "@maven//:com_trueaccord_scalapb_scalapb_runtime_2_12",
        "@maven//:net_sourceforge_argparse4j_argparse4j",
        "@maven//:org_scala_sbt_compiler_interface",
        "@maven//:org_scala_sbt_io_2_12",
        "@maven//:org_scala_sbt_test_interface",
        "@maven//:org_scala_sbt_util_control_2_12",
        "@maven//:org_scala_sbt_util_interface",
        "@maven//:org_scala_sbt_zinc_2_12",
        "@maven//:org_scala_sbt_zinc_classpath_2_12",
        "@maven//:org_scala_sbt_zinc_compile_core_2_12",
        "@maven//:org_scala_sbt_zinc_core_2_12",
        "@maven//:org_scala_sbt_zinc_persist_2_12",
    ],
)
