#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$DIR/functions.bash"

function main() {
  local return_code=0

  setup_testing_environment
  run_tests || local return_code=$?
  teardown_testing_environment

  exit $return_code
}

main

# vim:syntax=sh tabstop=2 shiftwidth=2 expandtab
