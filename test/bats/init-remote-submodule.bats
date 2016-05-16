#!/usr/bin/env bats

# Test skeleton funcitonality

load "$BATS_TEST_DIRNAME/bats_functions.bash"

function initialize_environment() {
  _initialize_environment "remote-submodule-environment"
}

@test "'--init' creates skeleton remote submodules recursively" {
  cd "$WORKING"

  # Is submodule directory there?
  [ -d "$WORKING/remote-submodule" ]

  # Is the sub-submodule there too?
  [ -f "$WORKING/remote-submodule/mo/mo" ]
}

# vim:syntax=sh tabstop=2 shiftwidth=2 expandtab
