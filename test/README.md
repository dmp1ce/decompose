Run the `run_tests_full.bash` script to run tests

Because of expensive environment setup, the `run_tests_full.bash` script wraps the `bats` command. This issue may change this in the future: https://github.com/sstephenson/bats/issues/3

The `run_tests_full.bash` script will create a Docker tester container.

Requires Docker only.

## Run tests without using Docker

If your local environment has the development version of decompose installed then you can run tests directly with bats using `bats test/bats`.

Requires:

- bats
- development decompose installed
- uuidgen
- chmod (GNU coreutils) 8.25
