#!/usr/bin/env bash

if gh release view "$(date --utc +'%y.%m')-1" >&2; then
  current_release="$(gh api '/repos/{owner}/{repo}/releases' | jq -r -c 'map(select(.draft == false and .prerelease == false)) | .[0].tag_name')"
  current_release_major_minor="$(echo $current_release | sed -e 's/^\(.*\)-.*/\1/')"
  current_release_version="$(echo $current_release | sed -e 's/^.*-\(.*\)/\1/')"
  >&2 echo "Found existing release for $current_release_major_minor: $current_release"
else
  current_release_major_minor="$(date --utc +'%y.%m')"
  current_release_version=0
  >&2 echo "No release found for $current_release_major_minor"
fi

new_version=$((current_release_version + 1))
new_release="$current_release_major_minor-$new_version"
>&2 echo "New release: $new_release"
echo "$new_release"
