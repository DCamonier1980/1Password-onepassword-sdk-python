#!/bin/bash

# Helper script to release the Python SDK

set -e

# Minimum glibc version we support
glibc_version=2-32

# These versions are being supported due to the SDKs supporting Python 3.8+
macOS_version_x86_64=10.9
macOS_version_arm64=11.0

acquire_wheels() {
    os_platform=$1
    machine_platform=$2
    version=

    case "$os_platform" in
        Darwin)
            if [[ "$machine_platform" == "x86_64" ]]; then
                version=$min_macOS_version_x86_64
                export MACOSX_DEPLOYMENT_TARGET=$macOS_version_x86_64
            else
                version=$min_macOS_version_arm64
                export MACOSX_DEPLOYMENT_TARGET=$macOS_version_arm64

            fi
            export PYTHON_OS_PLATFORM=$os_platform
            export PYTHON_MACHINE_PLATFORM=$machine_platform
            export _PYTHON_HOST_PLATFORM="macosx-${version}-${PYTHON_MACHINE_PLATFORM}"
            ;;
        Linux)
            export PYTHON_OS_PLATFORM=$os_platform
            export PYTHON_MACHINE_PLATFORM=$machine_platform
            export _PYTHON_HOST_PLATFORM="manylinux-${glibc_version}-${PYTHON_MACHINE_PLATFORM}"
            ;;
        Windows)
            export PYTHON_OS_PLATFORM=$os_platform
            export PYTHON_MACHINE_PLATFORM=$machine_platform
            export _PYTHON_HOST_PLATFORM="win-${PYTHON_MACHINE_PLATFORM}"
            ;;
        *)
            echo "Unsupported OS: $os_platform"
            exit 1
            ;;
    esac

    python3 -m build --wheel
    rm -rf build
}

# Read the contents of the files into variables
version=$(awk -F "['\"]" '/SDK_VERSION =/{print $2}' "src/release/version.py")
build=$(awk -F "['\"]" '/SDK_BUILD_NUMBER =/{print $2}' "src/release/version.py")
release_notes=$(< src/release/RELEASE-NOTES)


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

gh release create "v${version}" --title "Release ${version}" --notes "${release_notes}" --repo github.com/1Password/onepassword-sdk-python


# Acquire the wheels for different OS
acquire_wheels Darwin x86_64
acquire_wheels Darwin arm64
acquire_wheels Linux x86_64
acquire_wheels Linux aarch64
acquire_wheels Windows amd64

# Release on PyPi
python3 -m twine upload --repository testpypi dist/* --verbose