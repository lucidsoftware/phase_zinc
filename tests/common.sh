#!/bin/bash -e
###
# Borrowed from https://github.com/higherkindness/rules_scala/blob/b772564a20eee9271068cfba55147191385343bd/tests/common.sh
###

cd "$(dirname "$0")"
FILE="$0"

printf "\u001b[1;39m:::\u001b[0m\n"
printf "\u001b[1;39m  test file: $0\u001b[0m\n"
printf "\u001b[1;39m:::\u001b[0m\n"

error() {
    set +x
    printf "\u001b[1;31m::FAILURE::\u001b[0m $FILE:$2 exited with code $1\n"
}

finish() {
    set +x
    [ $1 != 0 ] || printf "\u001b[1;32m::SUCCESS::\u001b[0m\n"
}

trap 'error $? $LINENO' ERR
trap 'finish $?' EXIT

set -x
