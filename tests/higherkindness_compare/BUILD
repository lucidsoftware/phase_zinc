load(
    "@phase_zinc//rules:scala.bzl",
    "zinc_scala_library",
    "zinc_scala_test",
)
load(
    "@rules_scala_annex//rules:scala.bzl",
    "configure_bootstrap_scala",
    "configure_zinc_scala",
    "scala_library",
    "scala_test",
)

scala_version = "2.12.8"

compiler_classpath = [
    "@annex//:org_scala_lang_scala_compiler",
    "@annex//:org_scala_lang_scala_library",
    "@annex//:org_scala_lang_scala_reflect",
]

runtime_classpath = [
    "@annex//:org_scala_lang_scala_library",
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
        "@annex//:org_scala_sbt_compiler_interface",
        "@annex//:org_scala_sbt_util_interface",
    ],
)

configure_zinc_scala(
    name = "zinc",
    compiler_bridge = ":compiler_bridge",
    compiler_classpath = compiler_classpath,
    global_scalacopts = ["-nowarn"],
    runtime_classpath = runtime_classpath,
    version = scala_version,
    visibility = ["//visibility:public"],
)

scala_library(
    name = "course_higherkindness",
    srcs = ["Course.scala"],
    scala = ":zinc",
    visibility = ["//visibility:public"],
)

scala_library(
    name = "college_higherkindness",
    srcs = ["College.scala"],
    scala = ":zinc",
    visibility = ["//visibility:public"],
    deps = [
        ":course_higherkindness",
    ],
)

scala_test(
    name = "college_test_higherkindness",
    srcs = ["CollegeTest.scala"],
    scala = ":zinc",
    visibility = ["//visibility:public"],
    deps = [
        ":college_higherkindness",
        ":course_higherkindness",
        "@zinc//:joda_time_joda_time",
        "@zinc//:org_scalactic_scalactic_2_12",
        "@zinc//:org_scalatest_scalatest_2_12",
    ],
)

zinc_scala_library(
    name = "course_zinc",
    srcs = ["Course.scala"],
    visibility = ["//visibility:public"],
)

zinc_scala_library(
    name = "college_zinc",
    srcs = ["College.scala"],
    visibility = ["//visibility:public"],
    deps = [
        ":course_zinc",
    ],
)

zinc_scala_test(
    name = "college_test_zinc",
    srcs = ["CollegeTest.scala"],
    visibility = ["//visibility:public"],
    deps = [
        ":college_zinc",
        "@zinc//:joda_time_joda_time",
    ],
)
