load(
    "@phase_zinc//rules:scala.bzl",
    "zinc_scala_binary",
    "zinc_scala_library",
    "zinc_scala_test",
)

zinc_scala_binary(
    name = "binary",
    srcs = ["Binary.scala"],
    main_class = "com.phase_zinc.tests.zinc_output.Binary",
    visibility = ["//visibility:public"],
)

zinc_scala_library(
    name = "library",
    srcs = ["Library.scala"],
    visibility = ["//visibility:public"],
)

zinc_scala_test(
    name = "test",
    srcs = ["Test.scala"],
    visibility = ["//visibility:public"],
)
