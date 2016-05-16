#!/usr/bin/env bats

# Test skeleton funcitonality

load "$BATS_TEST_DIRNAME/bats_functions.bash"

@test "'--init' creates skeleton submodules" {
  cd "$WORKING"

  git -C "$WORKING/submodule-test" log
  # Is submodule directory there?
  [ -d "$WORKING/submodule-test" ]
  [ -d "$WORKING/submodule-test2" ]
}

# vim:syntax=sh tabstop=2 shiftwidth=2 expandtab
