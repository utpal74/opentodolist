#!/bin/bash

set -e

if [ -d "$HOME/Qt" ]; then
    echo "Qt is already installed... skipping installation!"
    exit 0
fi

if [ -n "$CI" ]; then
    QT_ARCHIVE_MACOS="/tmp/Qt-MacOS.zip"
    QT_ARCHIVE_IOS="/tmp/Qt-iOS.zip"
    QT_ARCHIVE_TOOLS="/tmp/Qt-Tools.zip"
    # 46171955 == Project ID of https://gitlab.com/rpdev/packages/qt6
    QT_URL_MACOS="https://gitlab.com/api/v4/projects/46171955/packages/generic/Qt6/$QT_VERSION/Qt-MacOS.zip"
    QT_URL_IOS="https://gitlab.com/api/v4/projects/46171955/packages/generic/Qt6/$QT_VERSION/Qt-iOS.zip"
    QT_URL_TOOLS="https://gitlab.com/api/v4/projects/46171955/packages/generic/Qt6/$QT_VERSION/Qt-Tools.zip"

    cd $HOME
    mkdir -p Qt

    curl -L -o archive.zip "$QT_URL_MACOS"
    unzip -q archive.zip
    rm archive.zip

    curl -L -o archive.zip "$QT_URL_TOOLS"
    unzip -q archive.zip
    rm archive.zip

    if [ -n "$QT_INSTALL_IOS" ]; then
        curl -L -o archive.zip "$QT_URL_IOS"
        unzip -q archive.zip
        rm archive.zip
    fi
fi
