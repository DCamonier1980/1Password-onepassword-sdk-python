#!/bin/bash

# Helper script to release the Python SDK

set -e

# Read the contents of the files into variables
version=$(awk -F "['\"]" '/SDK_VERSION =/{print $2}' "src/release/version.py")
build=$(awk -F "['\"]" '/SDK_BUILD_NUMBER =/{print $2}' "src/release/version.py")
changelog=$(< src/release/CHANGELOG)


# Check if Github CLI is installed
if ! command -v gh &> /dev/null; then
	echo "gh is not installed";\
	exit 1;\
fi

# Ensure GITHUB_TOKEN env var is set
if [ -z "${GITHUB_TOKEN}" ]; then
  echo "GITHUB_TOKEN environment variable is not set."
  exit 1
fi

git tag -a -s  "v${version}" -m "${version}"

# Push the tag to the branch
git push origin tag "v${version}"

gh release create "v${version}" --title "Release ${version}" --notes "${changelog}" --repo github.com/1Password/onepassword-sdk-python

