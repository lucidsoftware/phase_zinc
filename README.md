# phase_zinc

Phase_zinc is a custom phase allowing Bazel users to compile Scala using Zinc compiler. To learn what "customizable phases" are and how the phase architecture can help your Bazel project, see [this doc on customizable phases](https://github.com/bazelbuild/rules_scala/blob/master/docs/customizable_phase.md) on the Bazelbuild/rules_scala project.

This project is aimed at anyone who depends on the Bazelbuild/rules_scala project but would like to swap out the default XXX compiler with Zinc compiler. This is especially helpful for developers or companies whose codebases have large Bazel targets -- because Zinc is an incremental compiler, it can speed up builds significantly.
