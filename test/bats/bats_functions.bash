#!/bin/bash

function echo_tmpdir() {
  echo "$BATS_TMPDIR/$BATS_TEST_NAME"
}

# Override this function to change build environment to use
function initialize_environment() {
  _initialize_environment "build-test-environment"
}

function _initialize_environment() {
  # Directory for setting up tests
  local tmpdir=$(echo_tmpdir)
  mkdir -p "$tmpdir"

  # Setup git repository
  local git_url=$(realpath $tmpdir/$1)
  git -C "$git_url" init
  git -C "$git_url" config user.email "tester@example.com"
  git -C "$git_url" config user.name "tester"
  git -C "$git_url" add .
  git -C "$git_url" commit -m "Initial commit"

  # Init build and initialize environment
  local error_output=$(export HOME=$HOME && cd $WORKING && \
    $DECOMPOSE --init "$git_url" 2>&1 1>/dev/null)
  if [ -n "$error_output" ]; then
    echo "'decompose --init' had errors"
    echo "$error_output"
    return 1
  fi
}

function setup() {
  # Directory for setting up tests
  local tmpdir=$(echo_tmpdir)
  mkdir -p "$tmpdir"
 
  # Setup build test environment
  cp -r "$BATS_TEST_DIRNAME/fixtures/tests-workspace/." "$tmpdir"

  # Create test submodules
  mkdir "$tmpdir/submodule-test"
  git -C "$tmpdir/submodule-test" init
  git -C "$tmpdir/submodule-test" config user.email "tester@example.com"
  git -C "$tmpdir/submodule-test" config user.name "tester"
  touch "$tmpdir/submodule-test/afile"
  git -C "$tmpdir/submodule-test" add afile
  git -C "$tmpdir/submodule-test" commit -m "Initial commit 1"
  mkdir "$tmpdir/submodule-test2"
  git -C "$tmpdir/submodule-test2" init
  git -C "$tmpdir/submodule-test2" config user.email "tester@example.com"
  git -C "$tmpdir/submodule-test2" config user.name "tester"
  touch "$tmpdir/submodule-test2/bfile"
  git -C "$tmpdir/submodule-test2" add bfile
  git -C "$tmpdir/submodule-test2" commit -m "Initial commit 2"
  mkdir "$tmpdir/submodule-test3"
  git -C "$tmpdir/submodule-test3" init
  git -C "$tmpdir/submodule-test3" config user.email "tester@example.com"
  git -C "$tmpdir/submodule-test3" config user.name "tester"
  touch "$tmpdir/submodule-test3/cfile"
  git -C "$tmpdir/submodule-test3" add cfile
  git -C "$tmpdir/submodule-test3" commit -m "Initial commit 3"


  # Make and set home directory
  mkdir -p "$tmpdir/user-home"
  export HOME=$(realpath "$(echo_tmpdir)/user-home")

  # Set current working directory
  export WORKING="$tmpdir/build-test"
  mkdir -p "$tmpdir/build-test"

  # Set decompose alias
  export DECOMPOSE=$(realpath "$BATS_TEST_DIRNAME/../../decompose")

  initialize_environment
}

function teardown() {
  # Directory for setting up tests
  local tmpdir=$(echo_tmpdir)

  # Move generated test files to random temporary
  # directory where it will eventually be cleaned up
  mv "$tmpdir" "$tmpdir-$(uuidgen)"
}

# vim:syntax=sh tabstop=2 shiftwidth=2 expandtab
