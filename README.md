# phase_zinc

## Contents
*  [Overview](#overview)
*  [Files to note](#files-to-note)
*  [How to create a custom rule using phase_zinc](#how-to-create-a-custom-rule-using-phase_zinc)

## Overview
A custom phase extension allowing [bazelbuild/rules_scala](https://github.com/bazelbuild/rules_scala) users to use the [Zinc compiler](https://github.com/sbt/zinc). To learn what "customizable phases" are and how the phase architecture can help your Bazel project, see [this doc on customizable phases](https://github.com/bazelbuild/rules_scala/blob/master/docs/customizable_phase.md) on the [bazelbuild/rules_scala](https://github.com/bazelbuild/rules_scala) project.

This project is aimed at anyone who depends on the [bazelbuild/rules_scala](https://github.com/bazelbuild/rules_scala) project but would like to swap out the default Scala compiler with Zinc compiler. This is especially helpful for codebases that have Bazel targets with large numbers of source files-- if Bazel targets are not granular enough, builds can take a long time. Because Zinc is an incremental compiler, it can make builds significantly faster. However, be aware that Zinc can also add non-determinism to your builds.

## Files to note

The [rules](rules) directory contains definitions and implementations of the Zinc compiler phase. [rules/phases/phase_zinc_compile.bzl](rules/phases/phase_zinc_compile.bzl) defines the logic of how the phase works. [rules/ext/phase_zinc_compile_ext.bzl](rules/ext/phase_zinc_compile_ext.bzl) wraps the phase definition in an extension together with some extra attributes.

The [src/main/scala](src/main/scala) directory contains Scala and Zinc configuration data. See [src/main/scala/workers/BUILD](src/main/scala/workers/BUILD).

## How to create a custom rule using phase_zinc

To start, add this snippet to `WORKSPACE`:
```
phase_zinc_version = "553e3ff8e82025372c1342900f5e81b9de7b23ed" #INSERT UPDATED COMMIT HASH HERE

http_archive(
    name = "phase_zinc",
    sha256 = "199651d549f81aa23c6dc06b74084b3c4be149b91c7e387b3c1c6dbbee96aa30", #INSERT UPDATED SHA256 HERE
    strip_prefix = "phase_zinc-{}".format(phase_zinc_version),
    type = "zip",
    url = "https://github.com/lucidsoftware/phase_zinc/archive/{}.zip".format(phase_zinc_version),
)

load("@phase_zinc//rules:workspace.bzl", "zinc_repositories")

zinc_repositories()

load("@zinc//:defs.bzl", zinc_pinned_maven_install = "pinned_maven_install")

zinc_pinned_maven_install()
```
This adds the `phase_zinc` repo to your workspace and loads some dependencies. Make sure you have the desired commit hash (in case this repository is updated but this README is not). Also check to make sure the sha256 matches.

To add this phase to a rule, you have to pass the extension to a rule macro. Take `scala_binary` for example: first, load the rule macro from [bazelbuild/rules_scala](https://github.com/bazelbuild/rules_scala), then load the extension from `@phase_zinc` and finally pass the extension to the macro to define a custom rule. You'll also need to make sure you have loaded the [bazelbuild/rules_scala](https://github.com/bazelbuild/rules_scala) workspace to your own `WORKSPACE` file. In this example we assume it was loaded as `@io_bazel_rules_scala`):
```
load("@io_bazel_rules_scala//scala:advanced_usage/scala.bzl", "make_scala_binary")
load("@phase_zinc//rules/ext:phase_zinc_compile_ext.bzl", "ext_zinc_compile")

zinc_scala_binary = make_scala_binary(ext_zinc_compile)
```
Sweet, now you can use `zinc_scala_binary` as a normal rule!

If you still aren't sure how to implement this in your own code, check out [rules/scala.bzl](rules/scala.bzl) for an example. You can even pass multiple phases into a rule macro for additional functionality in your custom rule.
