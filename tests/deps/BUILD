load(
    "@phase_zinc//rules:scala.bzl",
    "zinc_scala_library",
    "zinc_scala_test",
)

zinc_scala_library(
    name = "a",
    srcs = ["A.scala"],
    visibility = ["//visibility:public"],
)

zinc_scala_library(
    name = "b",
    srcs = ["B.scala"],
    visibility = ["//visibility:public"],
    deps = [":a"],
)

zinc_scala_library(
    name = "c",
    srcs = ["C.scala"],
    visibility = ["//visibility:public"],
    deps = [":b"],
)

zinc_scala_test(
    name = "all_test",
    srcs = ["AllTest.scala"],
    visibility = ["//visibility:public"],
    deps = [
        ":a",
        ":b",
        ":c",
    ],
)
