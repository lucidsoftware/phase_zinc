# phase_zinc

## Contents
*  [Overview](#overview)
*  [Files included](#files-included)
*  [How to set up](#how-to-set-up)

## Overview
A custom phase extension allowing [bazelbuild/rules_scala](https://github.com/bazelbuild/rules_scala) users to use the [Zinc compiler](https://github.com/sbt/zinc). To learn what "customizable phases" are and how the phase architecture can help your Bazel project, see [this doc on customizable phases](https://github.com/bazelbuild/rules_scala/blob/master/docs/customizable_phase.md) on the [bazelbuild/rules_scala](https://github.com/bazelbuild/rules_scala) project.

This project is aimed at anyone who depends on the [bazelbuild/rules_scala](https://github.com/bazelbuild/rules_scala) project but would like to swap out the default Scala compiler with Zinc compiler. This is especially helpful for codebases that have Bazel targets with large numbers of source files-- if Bazel targets are not granular enough, builds can take a long time. Because Zinc is an incremental compiler, it can make builds significantly faster. However, be aware that Zinc can also add non-determinism to your builds.

## Files included

Phase_zinc defines a Zinc compiler phase, then adds this phase to three Bazel rules originally defined in [bazelbuild/rules_scala](https://github.com/bazelbuild/rules_scala): `scala_binary`, `scala_library` and `scala_test`. The new corresponding rules are named, respectively, `zinc_scala_binary`, `zinc_scala_library` and `zinc_scala_test`.

The [rules](rules) directory contains definitions and implementations of the Zinc compiler phase. [rules/phase/phase_zinc_compile.bzl](rules/phase/phase_zinc_compile.bzl) defines the logic of how the phase works. [rules/ext/phase_zinc_compile_ext.bzl](rules/ext/phase_zinc_compile_ext.bzl) wraps the phase definition in an extension together with some extra attributes. Finally, [rules/scala.bzl](rules/scala.bzl) passes the extension to a rule macro (e.g. `make_scala_binary`) to add the phase to a rule (e.g. creating `zinc_scala_binary`).

The [src/main/scala](src/main/scala) directory contains Scala and Zinc configuration data. See [src/main/scala/workers/BUILD](src/main/scala/workers/BUILD).

## How to set up

Here is an example of how to load and use the rule `zinc_scala_binary` in your own project. Similar steps can be taken to use `zinc_scala_library` or `zinc_scala_test`. 
 
To start, add this snippet to `WORKSPACE`:
```
phase_zinc_version = "9ebfe30b7074ab7a1411b2ce1c72f4c182c07e0e" #INSERT UPDATED COMMIT HASH HERE

http_archive(
    name = "phase_zinc",
    sha256 = "61112d0da1db63227f4573ce8da36f5b7f283c36aaa97b655111f711d538e521", #INSERT UPDATED SHA256 HERE
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


Sweet, now you can use `zinc_scala_binary` as a normal rule! Just add the following line to any `BUILD` file:
```
load("@phase_zinc//rules:scala.bzl", "zinc_scala_binary")
```
