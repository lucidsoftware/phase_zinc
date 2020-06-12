#!/bin/bash
###
# Borrowed from https://github.com/higherkindness/rules_scala/blob/b772564a20eee9271068cfba55147191385343bd/scripts/travis.sh
###

#
# Acts as a front end script for use with Travis CI
#

set -eox pipefail
cd "$(dirname "$0")/.."

. ./scripts/prepare-path.sh --force

case "$1" in

    "build")
        bazel build --show_progress_rate_limit=2 //...
        ;;

    "test")
        ./scripts/test.sh
        ;;

    "lint")
        ./scripts/format.sh check
        ;;
    "")
        echo "command not specified"
        exit 1
        ;;
    *)
        echo "$1 not understood"
        exit 1
        ;;
esac
