load("@rules_java//java:defs.bzl", "java_test")

java_test(
    name = "hello",
    srcs = ["TestHello.java"],
    test_class = "com.example.myproject.TestHello",
    deps = [
        "@maven//:junit_junit_4_12",
    ],
)
