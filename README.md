# phase_zinc

## Contents
*  [Overview](#overview)
*  [How to set up](#how-to-set-up)

## Overview
A custom phase extension allowing Bazel users to compile Scala source code using the [Zinc compiler](https://github.com/sbt/zinc). To learn what "customizable phases" are and how the phase architecture can help your Bazel project, see [this doc on customizable phases](https://github.com/bazelbuild/rules_scala/blob/master/docs/customizable_phase.md) on the Bazelbuild/rules_scala project.

This project is aimed at anyone who depends on the [Bazelbuild/rules_scala](https://github.com/bazelbuild/rules_scala) project but would like to swap out the default XXX compiler with Zinc compiler. This is especially helpful for developers or companies whose codebases have large Bazel targets -- if Bazel targets are not granular enough, builds can take a long time, but because Zinc is an incremental compiler, it can speed up builds significantly.

## How to set up

