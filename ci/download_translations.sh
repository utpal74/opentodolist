#!/bin/bash

set -e

SCRIPT_DIR="$(cd $(dirname "$0") && pwd)"
cd "$SCRIPT_DIR"
cd ..

if [ -n "$CI" ]; then
    dnf install -y \
        qt5-qtbase-devel \
        qt5-linguist \
        python3 \
        python3-pip \
        openssh-clients \
        git \
        git-lfs \
        curl \
        which \
        ncurses
    git lfs install --skip-repo
fi

export QT_QPA_PLATFORM=minimal

pip3 install poeditor fire
python3 ./bin/poeditor-client.py download $POEDITOR_TOKEN app/translations

if [ -z "$QT_PATH" ]; then
    QT_PATH=/usr/lib64/qt5/bin
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
    git add app/translations
    git commit -m "Downloaded Translations from POEditor"
    git push "git@gitlab.com:rpdev/opentodolist.git" HEAD:development
fi
