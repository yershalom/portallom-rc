#!/usr/bin/env bash
set -ex

BRANCH=$1
BUILD_NUMBER=$2

BRANCH_PREFIX="refs/heads/"
BRANCH_NAME=${BRANCH#$BRANCH_PREFIX}

case $BRANCH_NAME in
  develop)
    VERSION_TYPE=patch
    ;;
  main)
    VERSION_TYPE=$(lerna changed --json | jq -r .[].version)-master
    ;;
  *)
    echo "bad branch name ${BRANCH}"
    exit 1
    ;;
esac
git config --global user.email "mcas@microsoft.com"
git config --global user.name "Portallom Pipeline"
git checkout "${BRANCH_NAME}"

yarn bumpVersion -y -m "[SKIP CI] bumped ${VERSION_TYPE} from branch ${BRANCH_NAME} with build number ${BUILD_NUMBER}" ${VERSION_TYPE} || exit 1

exit 0

