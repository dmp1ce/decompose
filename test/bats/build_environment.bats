#!/usr/bin/env bats

# Tests that require a build environment

function echo_tmpdir() {
  echo "$BATS_TMPDIR/$BATS_TEST_NAME"
}

function setup() {
  # Directory for setting up tests
  local tmpdir=$(echo_tmpdir)
  mkdir -p "$tmpdir"
 
  # Setup build test environment
  cp -r "$BATS_TEST_DIRNAME/fixtures/tests-workspace/." "$tmpdir"

  # Make and set home directory
  mkdir -p "$tmpdir/user-home"
  export HOME=$(realpath "$(echo_tmpdir)/user-home")

  # Set current working directory
  export WORKING="$tmpdir/build-test"
  mkdir -p "$tmpdir/build-test"

  # Setup git repository
  local git_url=$(realpath $tmpdir/build-test-environment)
  git -C "$git_url" init
  git -C "$git_url" config user.email "tester@example.com"
  git -C "$git_url" config user.name "tester"
  git -C "$git_url" add .
  git -C "$git_url" commit -m "Initial commit"

  # Init build and initialize environment
  local error_output=$(export HOME=$HOME && cd $WORKING && \
    decompose --init "$git_url" 2>&1 1>/dev/null)
  if [ -n "$error_output" ]; then
    echo "'decompose --init' had errors"
    echo "$error_output"
    return 1
  fi
}

function teardown() {
  # Directory for setting up tests
  local tmpdir=$(echo_tmpdir)

  # Move generated test files to random temporary
  # directory where it will eventually be cleaned up
  mv "$tmpdir" "$tmpdir-$(uuidgen)"
}

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
