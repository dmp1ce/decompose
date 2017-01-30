#!/usr/bin/env bats

# Test current environment

@test "'realpath' exists" {
  run realpath --version

  echo "$output"
  [ "$status" -eq 0 ]
}

@test "'uuidgen' exists" {
  run uuidgen
  
  echo "$output"
  [ "$status" -eq 0 ]
}

# vim:syntax=sh tabstop=2 shiftwidth=2 expandtab
