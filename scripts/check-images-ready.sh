#!/usr/bin/env bash

set -o errexit
set -o xtrace

images=("$@")
found_images=()

for i in {1..20}; do
  for img in "${images[@]}"; do
    for fimg in "${found_images[@]}"; do
      [ "$fimg" == "$img" ] && continue 2
    done

    echo "Inspecting (${i} time): ${img}"
    if ! skopeo inspect docker://"${img}" &>/dev/null; then
      sleep 5m
      continue 2
    fi

    found_images+=("$img")
  done

  break
done
