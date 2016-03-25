#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$DIR/functions.bash"

function main() {
  teardown_testing_environment
  echo "Done."
}

main

# vim:syntax=sh tabstop=2 shiftwidth=2 expandtab
