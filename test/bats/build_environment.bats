#!/usr/bin/env bats

# Tests that require a build environment

load "$BATS_TEST_DIRNAME/bats_functions.bash"

# Verify setup worked correctly with some basic tests
@test "'WORKING' variable is setup" {
  echo "$WORKING"
  [ "$WORKING" ]
  [[ $WORKING == /tmp/* ]]
}
@test "'HOME' variable is setup" {
  echo "$HOME"
  [ "$HOME" ]
  [[ $HOME == /tmp/* ]]
}
@test "git initialized in setup" {
  local tmpdir=$(echo_tmpdir)
  local git_url=$(realpath $tmpdir/build-test-environment)
  run git -C "$git_url" config --list
  echo "$output"
  [ ${#lines[@]} -gt 3 ]
  [ ${lines[4]} == "user.email=tester@example.com" ]
}

@test "decompose runs with no error (if no parameter is giving)" {
  run decompose

  echo "$output"
  [ "$status" -eq 0 ]
}

@test "'decompose --build' outputs no errors" {
  local error_output=$(cd $WORKING && \
    decompose --build 2>&1 1>/dev/null)
  echo "$error_output"
  [ -z "$error_output" ]
}

@test "'decompose --build' creates files" {
  cd $WORKING
  decompose --build

  [ -e "$WORKING/testing" ]
}

@test "global data directory is created (probably obsolete test)" {
  [ -d "$HOME/.local/share/decompose" ]
}

@test "'decompose --build' returns 0 error code" {
  cd $WORKING
  run decompose --build
  [ "$status" -eq 0 ]
}

@test "'decompose --build' doesn't processes ignored files" {
  cd $WORKING
  run decompose --build
  
  [ ! -e "$WORKING/ignore_me/a_file" ]
}

@test "'decompose --init' fails on second attempt" {
  # Get build environment directory
  local tmpdir=$(echo_tmpdir)
  local environment_dir="$tmpdir/build-test-environment"

  echo "$HOME"
  cd "$WORKING" 
  run decompose --init "$environment_dir"

  echo "$output"
  [ "$status" -ne 0 ]
  [ "${lines[1]}" == ".decompose directory already exists. Aborting init." ]
}

@test "'decomopse --init' fails if .git exists" {
  cd "$WORKING"

  # Get build environment directory
  local tmpdir=$(echo_tmpdir)
  local environment_dir="$tmpdir/build-test-environment"

  run decompose --init "$environment_dir"
 
  echo "$output"
  [ "$status" -ne 0 ] 
  [ "${lines[1]}" == ".decompose directory already exists. Aborting init." ]
}

@test "Returns error code of the process" {
  cd "$WORKING"

  run decompose failed_process

  echo "$output"
  [ "$status" -eq 1 ]
}

@test "Missing process return error code of 1" {
  cd "$WORKING"

  run decompose missing_process

  echo "$output"
  [ "$status" -eq 1 ]
}

# vim:syntax=sh tabstop=2 shiftwidth=2 expandtab
