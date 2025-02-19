#!/usr/bin/env bash

set -o errexit
set -o xtrace

images=("$@")
found_images=()

function check_images_ready() {
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
  done

  if [ ${#images[@]} -ne ${#found_images[@]} ]; then
    printf "Some images not found:\n Expected: %s\n Found: %s\n" "${images[*]}" "${found_images[*]}" >/dev/stderr
    exit 1
  fi
}

check_images_ready
