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

function generate_sbom_for_images() {
  for img in "${images[@]}"; do
    echo "Generating ${img} SBOM and checksum"

    sbom_name="${img##*/}".sbom

    syft "$img" -o spdx-json >"$sbom_name"
    sha256sum "$sbom_name" >"$sbom_name".sha256
  done

  find . \( -name "*.sbom" -o -name "*.sbom.sha256" \) -print0 | tar --null -zcvf "longhorn-images-sbom.tar.gz" --files-from -
  tar -tvf longhorn-images-sbom.tar.gz
}

check_images_ready
#SBOM generation is disabled for now, because it's supported by https://github.com/longhorn/longhorn/blob/master/.github/workflows/generate-sbom.yml already
#generate_sbom_for_images
