load(
    "@phase_zinc//rules:scala.bzl",
    "zinc_scala_binary",
    "zinc_scala_library",
    "zinc_scala_test",
)

zinc_scala_binary(
    name = "scala_attr_binary",
    srcs = ["ScalaAttrBinary.scala"],
    main_class = "com.phase_zinc.tests.phase.ScalaAttrBinary",
    visibility = ["//visibility:public"],
)

zinc_scala_library(
    name = "scala_attr_library",
    srcs = ["ScalaAttrLibrary.scala"],
    visibility = ["//visibility:public"],
)

zinc_scala_test(
    name = "scala_attr_test",
    srcs = ["ScalaAttrTest.scala"],
    visibility = ["//visibility:public"],
)
