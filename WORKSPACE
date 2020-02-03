workspace(name = "phase_zinc")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# com_github_bazelbuild_buildtools

buildtools_tag = "0.29.0"

buildtools_sha256 = "05eb52437fb250c7591dd6cbcfd1f9b5b61d85d6b20f04b041e0830dd1ab39b3"

http_archive(
    name = "com_github_bazelbuild_buildtools",
    sha256 = buildtools_sha256,
    strip_prefix = "buildtools-{}".format(buildtools_tag),
    url = "https://github.com/bazelbuild/buildtools/archive/{}.zip".format(buildtools_tag),
)

load("@com_github_bazelbuild_buildtools//buildifier:deps.bzl", "buildifier_dependencies")

buildifier_dependencies()

# io_bazel_rules_go

rules_go_tag = "v0.20.2"

rules_go_sha256 = "b9aa86ec08a292b97ec4591cf578e020b35f98e12173bbd4a921f84f583aebd9"

http_archive(
    name = "io_bazel_rules_go",
    sha256 = rules_go_sha256,
    urls = [
        "https://storage.googleapis.com/bazel-mirror/github.com/bazelbuild/rules_go/releases/download/{tag}/rules_go-{tag}.tar.gz".format(tag = rules_go_tag),
        "https://github.com/bazelbuild/rules_go/releases/download/{tag}/rules_go-{tag}.tar.gz".format(tag = rules_go_tag),
    ],
)

load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")

go_rules_dependencies()

go_register_toolchains()

bazel_skylib_tag = "1.0.2"

bazel_skylib_sha256 = "97e70364e9249702246c0e9444bccdc4b847bed1eb03c5a3ece4f83dfe6abc44"

http_archive(
    name = "bazel_skylib",
    sha256 = bazel_skylib_sha256,
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/{tag}/bazel-skylib-{tag}.tar.gz".format(tag = bazel_skylib_tag),
        "https://github.com/bazelbuild/bazel-skylib/releases/download/{tag}/bazel-skylib-{tag}.tar.gz".format(tag = bazel_skylib_tag),
    ],
)

protobuf_tag = "3.10.1"

protobuf_sha256 = "678d91d8a939a1ef9cb268e1f20c14cd55e40361dc397bb5881e4e1e532679b1"

http_archive(
    name = "com_google_protobuf",
    sha256 = protobuf_sha256,
    strip_prefix = "protobuf-{}".format(protobuf_tag),
    type = "zip",
    url = "https://github.com/protocolbuffers/protobuf/archive/v{}.zip".format(protobuf_tag),
)

load("@com_google_protobuf//:protobuf_deps.bzl", "protobuf_deps")

protobuf_deps()

jdk_build_file_content = """
filegroup(
    name = "jdk",
    srcs = glob(["**/*"]),
    visibility = ["//visibility:public"],
)
filegroup(
    name = "java",
    srcs = ["bin/java"],
    visibility = ["//visibility:public"],
)
"""

http_archive(
    name = "jdk8-linux",
    build_file_content = jdk_build_file_content,
    sha256 = "dd28d6d2cde2b931caf94ac2422a2ad082ea62f0beee3bf7057317c53093de93",
    strip_prefix = "jdk8u212-b03",
    url = "https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u212-b03/OpenJDK8U-jdk_x64_linux_hotspot_8u212b03.tar.gz",
)

http_archive(
    name = "jdk8-osx",
    build_file_content = jdk_build_file_content,
    sha256 = "3d80857e1bb44bf4abe6d70ba3bb2aae412794d335abe46b26eb904ab6226fe0",
    strip_prefix = "jdk8u212-b03",
    url = "https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u212-b03/OpenJDK8U-jdk_x64_mac_hotspot_8u212b03.tar.gz",
)

################################################################################
# rules_jvm_external
################################################################################

RULES_JVM_EXTERNAL_TAG = "3.0"

RULES_JVM_EXTERNAL_SHA = "62133c125bf4109dfd9d2af64830208356ce4ef8b165a6ef15bbff7460b35c3a"

http_archive(
    name = "rules_jvm_external",
    sha256 = RULES_JVM_EXTERNAL_SHA,
    strip_prefix = "rules_jvm_external-%s" % RULES_JVM_EXTERNAL_TAG,
    url = "https://github.com/bazelbuild/rules_jvm_external/archive/%s.zip" % RULES_JVM_EXTERNAL_TAG,
)

load("@rules_jvm_external//:defs.bzl", "maven_install")

maven_install(
    artifacts = [
        "org.scala-lang:scala-compiler:2.12.10",
        "org.scala-lang:scala-library:2.12.10",
        "org.scala-lang:scala-reflect:2.12.10",
        "org.scala-sbt:compiler-interface:1.2.1",
        "org.scala-sbt:util-interface:1.2.1",
        "org.scala-sbt:zinc_2.12:1.2.1",
        "org.scala-sbt:zinc-compile-core_2.12:1.2.1",
        "org.scala-sbt:test-interface:1.0",
        "com.lihaoyi:sourcecode_2.12:0.1.4,",
        "net.sourceforge.argparse4j:argparse4j:0.8.1",
        "org.scala-sbt:util-logging_2.12:1.2.0",
        "org.scala-sbt:compiler-interface:1.2.1",
    ],
    maven_install_json = "//:maven_install.json",
    repositories = [
        "https://repo.maven.apache.org/maven2",
        "https://maven-central.storage-download.googleapis.com/maven2",
        "https://mirror.bazel.build/repo1.maven.org/maven2",
        "https://jcenter.bintray.com",
    ],
)

load("@maven//:defs.bzl", "pinned_maven_install")

pinned_maven_install()

################################################################################
# rules_scala
################################################################################

rules_scala_version = "30b80b03a410994a8abb93d5a3f81b0d1f5cb96f"  # update this as needed

rules_scala_sha = "7bb0b2087a378ac03fcd0d54e90ac66a890294013a5a4ced191e43d6e0801115"

http_archive(
    name = "io_bazel_rules_scala",
    sha256 = rules_scala_sha,
    strip_prefix = "rules_scala-%s" % rules_scala_version,
    type = "zip",
    url = "https://github.com/bazelbuild/rules_scala/archive/%s.zip" % rules_scala_version,
)

load("@io_bazel_rules_scala//scala:toolchains.bzl", "scala_register_toolchains")

scala_register_toolchains()

scala_version = "2.12.8"

scala_version_jar_shas = {
    "scala_compiler": "f34e9119f45abd41e85b9e121ba19dd9288b3b4af7f7047e86dc70236708d170",
    "scala_library": "321fb55685635c931eba4bc0d7668349da3f2c09aee2de93a70566066ff25c28",
    "scala_reflect": "4d6405395c4599ce04cea08ba082339e3e42135de9aae2923c9f5367e957315a",
}

load("@io_bazel_rules_scala//scala:scala.bzl", "scala_repositories")

scala_repositories(scala_version_shas = (scala_version, scala_version_jar_shas))

################################################################################
# phase_zinc
################################################################################

load("@phase_zinc//rules:workspace.bzl", "scala_repositories")

scala_repositories()
