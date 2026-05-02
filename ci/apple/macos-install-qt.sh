#!/bin/bash

set -e

if [ -d "$HOME/Qt" ]; then
    echo "Qt is already installed... skipping installation!"
    exit 0
fi

if [ -n "$CI" ]; then
    if [ -z "$QT_VERSION" ]; then
        echo "The variable QT_VERSION is not set"
        exit 1
    fi

    QT_ARCHIVE_MACOS="/tmp/Qt-MacOS.zip"
    QT_ARCHIVE_IOS="/tmp/Qt-iOS.zip"
    # 46171955 == Project ID of https://gitlab.com/rpdev/packages/qt6
    GITLAB_API_V4_URL="${CI_API_V4_URL:-https://gitlab.com/api/v4}"
    QT_PACKAGE_PROJECT_ID="${QT_PACKAGE_PROJECT_ID:-46171955}"
    QT_URL_MACOS="$GITLAB_API_V4_URL/projects/$QT_PACKAGE_PROJECT_ID/packages/generic/Qt6/$QT_VERSION/Qt-MacOS.zip"
    QT_URL_IOS="$GITLAB_API_V4_URL/projects/$QT_PACKAGE_PROJECT_ID/packages/generic/Qt6/$QT_VERSION/Qt-iOS.zip"

    CURL_AUTH_HEADER=()
    if [ -n "$QT_PACKAGE_REGISTRY_TOKEN" ]; then
        CURL_AUTH_HEADER=(--header "PRIVATE-TOKEN: $QT_PACKAGE_REGISTRY_TOKEN")
    elif [ -n "$CI_JOB_TOKEN" ]; then
        CURL_AUTH_HEADER=(--header "JOB-TOKEN: $CI_JOB_TOKEN")
    fi

    download_and_extract_qt_archive() {
        local url="$1"
        local archive_path="$2"

        echo "Downloading Qt archive from $url"
        curl --fail --location --show-error "${CURL_AUTH_HEADER[@]}" -o "$archive_path" "$url"
        unzip -q "$archive_path"
        rm "$archive_path"
    }

    cd $HOME
    mkdir -p Qt

    download_and_extract_qt_archive "$QT_URL_MACOS" "$QT_ARCHIVE_MACOS"

    if [ -n "$QT_INSTALL_IOS" ]; then
        download_and_extract_qt_archive "$QT_URL_IOS" "$QT_ARCHIVE_IOS"
    fi

    if command -v xattr >/dev/null 2>&1; then
        xattr -cr Qt || true
    fi
fi
