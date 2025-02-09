#!/usr/bin/env bash

set -o errexit
set -o xtrace

if [ "$#" -ne 2 ]; then
  echo "Illegal number of arguments. source branch and new_branch are required." >/dev/stderr
  exit 1
fi

source_branch=$1
new_branch=$2
repos_dir=.repos

repos=(
  "longhorn/longhorn"
  "longhorn/longhorn-manager"
  "longhorn/longhorn-instance-manager"
  "longhorn/longhorn-engine"
  "longhorn/longhorn-share-manager"
  "longhorn/backing-image-manager"
  "longhorn/longhorn-ui"
  "longhorn/longhorn-tests"
  "longhorn/cli"
  "longhorn/dep-versions"
  # "longhorn/longhorn-spdk-engine" only needed since GA
)

function teardown() {
  rm -rf $repos_dir
}
trap teardown EXIT

mkdir -p $repos_dir

pushd $repos_dir
for repo in "${repos[@]}"; do
  gh repo clone "${repo}" -- --branch "${source_branch}"

  pushd "${repo##*/}"
  git checkout -b "${new_branch}"
  git push -u origin "${new_branch}"
  popd
done
popd
