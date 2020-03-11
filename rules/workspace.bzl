load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@rules_jvm_external//:defs.bzl", "maven_install")

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
        sha256 = "24cd30dcb37c2b24f962118f49489c98a66b49600cfd7fbb9eab68475ddd56a2",
        url = "https://repo.maven.apache.org/maven2/org/scala-sbt/compiler-bridge_2.12/1.3.4/compiler-bridge_2.12-1.3.4-sources.jar",
    )

def zinc_repositories():
    phase_zinc_artifacts = [
        "org.scala-lang:scala-compiler:2.12.10",
        "org.scala-lang:scala-library:2.12.10",
        "org.scala-lang:scala-reflect:2.12.10",
        "org.scala-sbt:test-interface:1.0",
        "org.scala-sbt:util-interface:1.3.0",
        "org.scala-sbt:util-logging_2.12:1.3.0",
        "org.scala-sbt:compiler-interface:1.3.4",
        "org.scala-sbt:zinc_2.12:1.3.4",
        "org.scala-sbt:zinc-compile-core_2.12:1.3.4",
        "net.sourceforge.argparse4j:argparse4j:0.8.1",
        "com.lihaoyi:sourcecode_2.12:0.1.4,",
    ]
    tests_artifacts = [
        "org.scalatest:scalatest_2.12:3.0.5",
        "joda-time:joda-time:2.3",
    ]
    maven_install(
        name = "zinc",
        artifacts = phase_zinc_artifacts + tests_artifacts,
        maven_install_json = "@phase_zinc//:zinc_install.json",
        repositories = [
            "https://repo.maven.apache.org/maven2",
            "https://maven-central.storage-download.googleapis.com/maven2",
            "https://mirror.bazel.build/repo1.maven.org/maven2",
            "https://jcenter.bintray.com",
        ],
    )
