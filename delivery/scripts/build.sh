#!/bin/bash

set -e
set -x

LIBRARY_NAME="clipspy"
SCRIPT_FOLDER="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT_FOLDER="${SCRIPT_FOLDER}/../.."
DIST_FOLDER="${PROJECT_ROOT_FOLDER}/dist"

CURRENT_LOCAL_VERSION="$(cat "${PROJECT_ROOT_FOLDER}/version.txt")"
ARTIFACTORY_TARGET_FOLDER="${WORKSPACE}/target/artifactory/${LIBRARY_NAME}/${CURRENT_LOCAL_VERSION}"

apt-get install libffi-dev
pip install -r "${PROJECT_ROOT_FOLDER}/requirements.txt"

echo "*******************************"
echo "* Building clipspy from clips *"
echo "*******************************"

cd "${PROJECT_ROOT_FOLDER}"

make build

# Versioning is performed by manual modification of version.txt file

echo "**********************************"
echo "*           Artifacts            *"
echo "**********************************"

mkdir -p "${ARTIFACTORY_TARGET_FOLDER}"
cp -r "${DIST_FOLDER}"/* "${ARTIFACTORY_TARGET_FOLDER}"
