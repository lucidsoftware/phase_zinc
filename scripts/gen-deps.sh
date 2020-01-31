#!/bin/sh -e
###
# Borrowed from https://github.com/higherkindness/rules_scala
###

#
# Regenerates the external dependencies lock file using rules_jvm_external
#

cd "$(dirname "$0")/.."

echo "generating dependencies for main workspace"
bazel run @unpinned_maven//:pin
