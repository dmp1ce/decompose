#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$DIR/functions.bash"

function main() {
  local return_code=0

  run_tests || local return_code=$?

  exit $return_code
}

main

# vim:syntax=sh tabstop=2 shiftwidth=2 expandtab
