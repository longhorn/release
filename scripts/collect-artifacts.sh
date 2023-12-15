#!/usr/bin/env bash

set -o errexit
set -o xtrace

if [ "$#" -ne 2 ]; then
  echo "Illegal number of arguments. longhorn repo dir and chart repo dir are required." >/dev/stderr
  exit 1
fi

longhorn_repo_dir=$1
longhorn_chart_repo_dir=$2

tar -czf charts.tar.gz -C .renote/"$longhorn_chart_repo_dir" .

for f in "longhorn.yaml" "longhorn-images.txt"; do
  cp .renote/"$longhorn_repo_dir"/deploy/$f $f || true
done
