#!/bin/bash

function setup_testing_environment() {
  echo "Setting up Docker testing environment ..."
#  # Create dind daemon with a mount to project.
#  testing_env_build=$(docker run --privileged --name decompose-docker-testing -d docker:dind)
#  [ "$?" == "1" ] && echo "$testing_env_build"
#
#  # Build testing image
#  local project_directory=$(readlink -f "$DIR/../")
#  # Copy volume so we can safely dereference symlinks
#  # Create docker container for doing tests
#  testing_env_build=$(docker run -v $project_directory:/project --rm --link decompose-docker-testing:docker docker sh -c "cp -rL /project /project-no-symlinks && \
#cp -rL /project/. /project-no-symlinks/test/bats/fixtures && \
#docker build -t tester /project-no-symlinks/test/bats/fixtures/.")
#  [ "$?" == "1" ] && echo "$testing_env_build"

  # Build testing image
  local project_directory=$(readlink -f "$DIR/../")
  local tmp_dockerfile_build="/tmp/$(uuidgen)"
  # Create docker container for doing tests
  cp -rL "$project_directory/."	"$tmp_dockerfile_build"
  cp -rL "$project_directory/."	"$tmp_dockerfile_build/test/bats/fixtures"
  local dockerfile_build_output=$(docker build -t decompose-unit-tester "$tmp_dockerfile_build/test/bats/fixtures/.")
#  testing_env_build=$(sh -c "cp -rL /project /project-no-symlinks && \
#cp -rL /project/. /project-no-symlinks/test/bats/fixtures && \
#docker build -t tester /project-no-symlinks/test/bats/fixtures/.")
  [ "$?" == "1" ] && echo "$dockerfile_build_output"

}

function run_tests() {
  #local tester_image="docker run --rm --link decompose-docker-testing:docker docker run --rm tester"
  local tester_image="docker run --rm decompose-unit-tester"
  return_code=0

  echo "== Running BATS tests =="
  echo "Testing environment tests"
  $tester_image bats /app/test/bats/environment.bats
  local return_code+=$?

  # Fail here if build environment didn't pass.
  if [ "$return_code" -gt 0 ]; then
    return "$return_code"
  fi

  echo -e "\nInternal functions tests"
  $tester_image bats /app/test/bats/internal_functions.bats
  local return_code+=$?
  
  echo -e "\nBuild environment tests"
  $tester_image bats /app/test/bats/build_environment.bats
  local return_code+=$?

  echo -e "\nSkeleton tests"
  $tester_image bats /app/test/bats/skeleton.bats
  local return_code+=$?
  $tester_image bats /app/test/bats/init-remote-submodule.bats
  local return_code+=$?

  return "$return_code"
}

function teardown_testing_environment() {
  echo "Teardown Docker testing environment ..."
  #testing_env_cleanup=$(docker rm -f decompose-docker-testing)
  #[ "$?" == "1" ] && echo "$testing_env_cleanup"

  testing_env_cleanup=$(docker rmi decompose-unit-tester)
  [ "$?" == "1" ] && echo "$testing_env_cleanup"
}
