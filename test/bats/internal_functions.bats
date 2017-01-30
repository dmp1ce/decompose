#!/usr/bin/env bats

# Source decompose functions
load "$BATS_TEST_DIRNAME/../../decompose-functions"
load "$BATS_TEST_DIRNAME/../../completion/decompose-bash-completion-functions"

@test "decompose-print-help prints something" {
  local function_output=$(decompose-print-help)
  echo $function_output
  [ ! -z "$function_output" ]
}

@test "decompose-print-help no errors" {
  local function_output=$(decompose-print-help 2>&1 1>/dev/null)
  echo $function_output
  [ ! -n "$function_output" ]
}

@test "internal function '_decompose-project-root' with parameter" {
  # Create temporary working and home directory to test function
  export WORKING="$BATS_TMPDIR/$BATS_TEST_NAME/working"
  export HOME="$BATS_TMPDIR/$BATS_TEST_NAME/home"
  mkdir -p "$WORKING/.decompose"
  mkdir -p "$HOME"
  cd $WORKING

  local project_root
  _decompose-project-root project_root

  echo $project_root
  [ "$project_root" == "$WORKING" ]

  mv "$BATS_TMPDIR/$BATS_TEST_NAME" "$BATS_TMPDIR/$BATS_TEST_NAME"-$(uuidgen)
}

@test "internal function '_decompose-project-root' without parameter" {
  # Create temporary working and home directory to test function
  export WORKING="$BATS_TMPDIR/$BATS_TEST_NAME/working"
  export HOME="$BATS_TMPDIR/$BATS_TEST_NAME/home"
  mkdir -p "$WORKING/.decompose"
  mkdir -p "$HOME"
  cd $WORKING

  # Using the function without parameter should echo working directory.
  project_root_echo=$(cd $WORKING; _decompose-project-root)
  [ "$project_root_echo" == "$WORKING" ]

  mv "$BATS_TMPDIR/$BATS_TEST_NAME" "$BATS_TMPDIR/$BATS_TEST_NAME"-$(uuidgen)
}

@test "internal function '_decompose-chmod-reference' with valid parameters" {
  mkdir -p "$BATS_TMPDIR/$BATS_TEST_NAME"
  cd "$BATS_TMPDIR/$BATS_TEST_NAME"
  touch test-reference
  touch test2

  # Simply test to see if 'stat' and 'chmod' work in this environment
  run _decompose-chmod-reference test-reference test2

  # Cleanup a bit after running test
  rm test-reference
  rm test2
  cd "$BATS_TMPDIR"
  rmdir "$BATS_TMPDIR/$BATS_TEST_NAME"

  # Verify that the test passed
  echo "$output"
  [ "$status" -eq 0 ]
}

# vim:syntax=sh tabstop=2 shiftwidth=2 expandtab
