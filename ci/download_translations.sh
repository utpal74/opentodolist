#!/bin/bash

set -e

SCRIPT_DIR="$(cd $(dirname "$0") && pwd)"
cd "$SCRIPT_DIR"
cd ..

export QT_QPA_PLATFORM=minimal

rm -rf .venv-download-translations
python3 -m venv .venv-download-translations
. .venv-download-translations/bin/activate

pip install poeditor fire
python ./bin/poeditor-client.py download $POEDITOR_TOKEN src/translations

if [ -z "$QT_PATH" ]; then
    QT_PATH=/usr/lib64/qt6/bin
    OS=$(uname -s)
    if [ $OS == "Darwin" ]; then
        QT_PATH=$(echo $HOME/Qt/*/macos/bin | sort --version-sort | tail -n1)
    fi
 fi

./bin/po-to-ts.sh $QT_PATH/lconvert
./bin/update-translations.sh $QT_PATH/lupdate

if [ -n "$CI" ]; then
    eval $(ssh-agent -s)
    export SECURE_FILES_DOWNLOAD_PATH=.secure-files
    curl --silent "https://gitlab.com/gitlab-org/incubation-engineering/mobile-devops/download-secure-files/-/raw/main/installer" | bash
    chmod go-rwx $SECURE_FILES_DOWNLOAD_PATH/opentodolist_deploy_key
    ssh-add $SECURE_FILES_DOWNLOAD_PATH/opentodolist_deploy_key
    mkdir -p ~/.ssh
    ssh-keyscan -t rsa gitlab.com >> ~/.ssh/known_hosts
    git config --global user.name "Martin Hoeher"
    git config --global user.email "martin@rpdev.net"
    git add src/translations
    git commit -m "Downloaded Translations from POEditor"
    git push "git@gitlab.com:rpdev/opentodolist.git" HEAD:development
fi
