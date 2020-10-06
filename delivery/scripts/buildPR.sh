#!/bin/bash

set -e
set -x

SCRIPT_FOLDER="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT_FOLDER="${SCRIPT_FOLDER}/../.."

pip install -r "${PROJECT_ROOT_FOLDER}/requirements.txt"

echo "*********************************"
echo "* Generating clipspy from clips *"
echo "*********************************"

cd "${PROJECT_ROOT_FOLDER}"

make install

echo "*****************"
echo "* Running tests *"
echo "*****************"

make test