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

@test "'--init' create skeleton submodule with space in path" {
  cd "$WORKING"
  ls

  echo "$output"
  [ -d "$WORKING/submodule test with space" ]
}

@test "'--init' create skeleton symlinks" {
  [ -L "$WORKING/symlink-test" ]
}

@test "'--init' create skeleton symlinks with spaces in path and name" {
  [ -L "$WORKING/symlink test with space" ]
}

# vim:syntax=sh tabstop=2 shiftwidth=2 expandtab
