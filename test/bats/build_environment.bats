#!/usr/bin/env bats

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
  git config --global user.email "tester@example.com"
  git config --global user.name "tester"
  git -C "$git_url" init >/dev/null
  git -C "$git_url" add .
  git -C "$git_url" commit -m "Initial commit" >/dev/null

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
  run git config --list
  [ ${lines[0]} == "user.email=tester@example.com" ]
}

@test "decompose runs with no error" {
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

# vim:syntax=sh tabstop=2 shiftwidth=2 expandtab
