load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

_SRC_FILEGROUP_BUILD_FILE_CONTENT = """
filegroup(
    name = "src",
    srcs = glob(["**/*.scala", "**/*.java"]),
    visibility = ["//visibility:public"]
)"""

def scala_repositories():
    http_archive(
        name = "compiler_bridge_2_12",
        build_file_content = _SRC_FILEGROUP_BUILD_FILE_CONTENT,
        sha256 = "d7a5dbc384c2c86479b30539cef911c256b7b3861ced68699b116e05b9357c9b",
        url = "https://repo.maven.apache.org/maven2/org/scala-sbt/compiler-bridge_2.12/1.2.1/compiler-bridge_2.12-1.2.1-sources.jar",
    )
