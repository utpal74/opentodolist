#!/bin/bash

# Download secrets during CI and "install" them, e.g. import certificates
# into a new, temporary keychain and move provisioning profiles
# to the correct location.

set -e

# Fetch secure files - see https://docs.gitlab.com/ee/ci/secure_files/index.html#use-secure-files-in-cicd-jobs
if [ -n "$CI" ]; then
    export SECURE_FILES_DOWNLOAD_PATH=.secure-files
    curl --silent "https://gitlab.com/gitlab-org/incubation-engineering/mobile-devops/download-secure-files/-/raw/main/installer" | bash

    # We need to manually import certificates. On the build machine, export them
    # following the instructions here:
    # https://docs.github.com/en/actions/deployment/deploying-xcode-applications/installing-an-apple-certificate-on-macos-runners-for-xcode-development
    # Add them as secure files in the GitLab project settings.

    # The same needs to be done with provisioning profiles. Follow the instructions here:
    # https://ioscodesigning.io/exporting-code-signing-files/
    # The profiles can be found in ~/Library/MobileDevice/Provisioning Profiles/
    # after downloading them in Xcode.

    # Now, we can move everything in place following the instructions from the GitHub
    # documentation above:
    # create variables
    CERTIFICATE_PATH=$RUNNER_TEMP/build_certificate.p12
    PP_PATH=$RUNNER_TEMP/build_pp.mobileprovision

    KEYCHAIN_PATH=$PWD/$SECURE_FILES_DOWNLOAD_PATH/app-signing.keychain-db
    KEYCHAIN_PASSWORD="temporary-1234" # Gets discarded anyway - hence, this is as good as a generated one

    # create temporary keychain
    security create-keychain -p "$KEYCHAIN_PASSWORD" $KEYCHAIN_PATH
    security set-keychain-settings -lut 21600 $KEYCHAIN_PATH
    security unlock-keychain -p "$KEYCHAIN_PASSWORD" $KEYCHAIN_PATH

    import_apple_intermediate_certificate() {
        local url="$1"
        local cert_path="$RUNNER_TEMP/$(basename "$url")"

        if curl --fail --location --show-error --silent -o "$cert_path" "$url"; then
            security import "$cert_path" -k "$KEYCHAIN_PATH" -T /usr/bin/codesign -T /usr/bin/security || true
        else
            echo "Could not download Apple intermediate certificate from $url"
        fi
    }

    import_apple_root_certificate() {
        local url="$1"
        local cert_path="$RUNNER_TEMP/$(basename "$url")"

        if curl --fail --location --show-error --silent -o "$cert_path" "$url"; then
            security import "$cert_path" -k "$KEYCHAIN_PATH" -T /usr/bin/codesign -T /usr/bin/security || true
            security add-trusted-cert -d -r trustRoot -k "$KEYCHAIN_PATH" "$cert_path" || true
        else
            echo "Could not download Apple root certificate from $url"
        fi
    }

    # Code signing identities need the Apple intermediate certificates to build
    # a trust chain on fresh CI runners.
    import_apple_root_certificate "https://www.apple.com/certificateauthority/AppleIncRootCertificate.cer"
    import_apple_root_certificate "https://www.apple.com/certificateauthority/AppleRootCA-G2.cer"
    import_apple_root_certificate "https://www.apple.com/certificateauthority/AppleRootCA-G3.cer"
    import_apple_intermediate_certificate "https://www.apple.com/certificateauthority/AppleWWDRCAG2.cer"
    import_apple_intermediate_certificate "https://www.apple.com/certificateauthority/AppleWWDRCAG3.cer"
    import_apple_intermediate_certificate "https://www.apple.com/certificateauthority/AppleWWDRCAG4.cer"
    import_apple_intermediate_certificate "https://www.apple.com/certificateauthority/AppleWWDRCAG5.cer"
    import_apple_intermediate_certificate "https://www.apple.com/certificateauthority/AppleWWDRCAG6.cer"
    import_apple_intermediate_certificate "https://www.apple.com/certificateauthority/DeveloperIDG2CA.cer"

    # import certificate to keychain
    for cert in $PWD/$SECURE_FILES_DOWNLOAD_PATH/*.p12; do
        security import $cert -P "$APPLE_CERTIFICATES_PASSWORD" -A -t cert -f pkcs12 -k $KEYCHAIN_PATH
    done
    security set-key-partition-list -S apple-tool:,apple: -s -k "$KEYCHAIN_PASSWORD" $KEYCHAIN_PATH
    security list-keychain -d user -s $KEYCHAIN_PATH
    security find-identity -v -p codesigning $KEYCHAIN_PATH || true

    # apply provisioning profile
    mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
    for profile in "$PWD/$SECURE_FILES_DOWNLOAD_PATH"/*.provisionprofile "$PWD/$SECURE_FILES_DOWNLOAD_PATH"/*.mobileprovision; do
        if [ -f "$profile" ]; then
            cp "$profile" ~/Library/MobileDevice/Provisioning\ Profiles
        fi
    done
else
    XCODEBUILD_FLAGS=""
fi
