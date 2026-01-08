#!/bin/bash

set -e

SCRIPT_DIR="$(cd $(dirname "$0") && pwd)"
cd "$SCRIPT_DIR"
cd ..

export QT_QPA_PLATFORM=minimal

./bin/update-translations.sh $QT_PATH/lupdate
./bin/ts-to-po.sh $QT_PATH/lconvert

rm -rf .venv-upload-translations
python3 -m venv .venv-upload-translations
. .venv-upload-translations/bin/activate
pip install poeditor fire
python3 ./bin/poeditor-client.py upload $POEDITOR_TOKEN
