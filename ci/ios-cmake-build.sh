#!/bin/bash

set -e

# Install secrets when running in CI:
. ci/apple/get-secrets.sh

# Install Qt in CI if needed
export QT_INSTALL_IOS="1"
bash ci/apple/macos-install-qt.sh

# Install CMake/Ninja in CI:
. ci/apple/install-build-tools.sh

if [ ! -d "$QT_INSTALLATION_DIR" ]; then
    if [ -d "$HOME/Qt" ]; then
        QT_INSTALLATION_DIR="$HOME/Qt"
    else
        echo "The variable QT_INSTALLATION_DIR is not set"
        exit 1
    fi
fi
echo "Using Qt installation in $QT_INSTALLATION_DIR"

if [ -z "$QT_VERSION" ]; then
    QT_VERSION=$(ls "$QT_INSTALLATION_DIR" | grep -E '\d+\.\d+\.\d+' | sort -V | tail -n1)
fi
echo "Using Qt $QT_VERSION"

QT_DIR_IOS=$QT_INSTALLATION_DIR/$QT_VERSION/ios
QT_DIR=$QT_INSTALLATION_DIR/$QT_VERSION/macos
IOS_BUNDLE_IDENTIFIER="${IOS_BUNDLE_IDENTIFIER:-net.rpdev.OpenTodoList}"
IOS_TEAM_ID="${IOS_TEAM_ID:-786Z636JV9}"
IOS_CODE_SIGN_IDENTITY="${IOS_CODE_SIGN_IDENTITY:-Apple Distribution}"

find_ios_provisioning_profile() {
    local bundle_identifier="$1"
    local profile

    for profile in "$HOME"/Library/MobileDevice/Provisioning\ Profiles/*.mobileprovision; do
        if [ ! -f "$profile" ]; then
            continue
        fi

        local plist
        plist=$(mktemp)
        if ! security cms -D -i "$profile" -o "$plist" >/dev/null 2>&1; then
            rm -f "$plist"
            continue
        fi

        local app_identifier
        local profile_name
        app_identifier=$(plutil -extract Entitlements.application-identifier raw -o - "$plist" 2>/dev/null || true)
        profile_name=$(plutil -extract Name raw -o - "$plist" 2>/dev/null || true)
        rm -f "$plist"

        case "$app_identifier" in
            *."$bundle_identifier"|"$IOS_TEAM_ID.$bundle_identifier")
                if [ -n "$profile_name" ]; then
                    echo "$profile_name"
                    return 0
                fi
                ;;
        esac
    done

    return 1
}

if [ -z "$IOS_PROVISIONING_PROFILE_SPECIFIER" ]; then
    IOS_PROVISIONING_PROFILE_SPECIFIER=$(find_ios_provisioning_profile "$IOS_BUNDLE_IDENTIFIER" || true)
fi

echo "Available code signing identities:"
security find-identity -v -p codesigning || true
echo "Using iOS bundle identifier: $IOS_BUNDLE_IDENTIFIER"
echo "Using iOS team ID: $IOS_TEAM_ID"
echo "Using iOS code signing identity: $IOS_CODE_SIGN_IDENTITY"
echo "Using iOS provisioning profile: $IOS_PROVISIONING_PROFILE_SPECIFIER"

if [ -z "$IOS_PROVISIONING_PROFILE_SPECIFIER" ]; then
    echo "No provisioning profile found for $IOS_BUNDLE_IDENTIFIER"
    exit 1
fi

EXPORT_OPTIONS_PLIST=$(mktemp)
cat > "$EXPORT_OPTIONS_PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>app-store</string>
    <key>provisioningProfiles</key>
    <dict>
        <key>$IOS_BUNDLE_IDENTIFIER</key>
        <string>$IOS_PROVISIONING_PROFILE_SPECIFIER</string>
    </dict>
    <key>signingCertificate</key>
    <string>$IOS_CODE_SIGN_IDENTITY</string>
    <key>signingStyle</key>
    <string>manual</string>
    <key>stripSwiftSymbols</key>
    <true/>
    <key>teamID</key>
    <string>$IOS_TEAM_ID</string>
    <key>uploadSymbols</key>
    <true/>
</dict>
</plist>
EOF

run_qt_tool_smoke_tests() {
    local qt_dir="$1"
    local label="$2"
    local qmake="$qt_dir/bin/qmake"
    local tool

    echo "Checking Qt tools for $label in $qt_dir"
    "$qmake" -query QT_VERSION
    "$qmake" -query QT_INSTALL_BINS
    "$qmake" -query QT_INSTALL_LIBEXECS
    "$qmake" -query QT_HOST_BINS
    "$qmake" -query QT_HOST_LIBEXECS

    for tool in moc rcc qmlcachegen qmltyperegistrar macdeployqt; do
        local tool_path=""
        for dir in \
            "$("$qmake" -query QT_HOST_BINS 2>/dev/null)" \
            "$("$qmake" -query QT_HOST_LIBEXECS 2>/dev/null)" \
            "$("$qmake" -query QT_INSTALL_BINS 2>/dev/null)" \
            "$("$qmake" -query QT_INSTALL_LIBEXECS 2>/dev/null)"; do
            if [ -x "$dir/$tool" ]; then
                tool_path="$dir/$tool"
                break
            fi
        done

        if [ -z "$tool_path" ]; then
            echo "Qt tool $tool not found for $label"
            continue
        fi

        echo "Found Qt tool $tool: $tool_path"
        file "$tool_path"
        case "$tool" in
            moc|rcc)
                "$tool_path" -v
                ;;
            *)
                if "$tool_path" -h >/dev/null; then
                    :
                else
                    local status=$?
                    echo "Qt tool $tool returned status $status while printing help"
                    if [ "$status" -eq 137 ]; then
                        exit "$status"
                    fi
                fi
                ;;
        esac
    done
}

run_qt_tool_smoke_tests "$QT_DIR_IOS" ios
run_qt_tool_smoke_tests "$QT_DIR" macos


HOST_CMAKE=$(command -v cmake || true)
if [ -z "$HOST_CMAKE" ]; then
    echo "CMake is required"
    exit 1
fi
CMAKE_BIN=$HOST_CMAKE
RESOLVED_CMAKE_BIN=$(command -v "$CMAKE_BIN")

echo "Using CMake: $CMAKE_BIN"
echo "Resolved CMake: $RESOLVED_CMAKE_BIN"
file "$RESOLVED_CMAKE_BIN"
codesign --verify --verbose=2 "$RESOLVED_CMAKE_BIN" || true


rm -rf build-ios-cmake
mkdir -p build-ios-cmake
cd build-ios-cmake

"$CMAKE_BIN" \
    -S .. \
    -B . \
    -GXcode \
    -DCMAKE_TOOLCHAIN_FILE=$QT_DIR_IOS/lib/cmake/Qt6/qt.toolchain.cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DQT_QMAKE_EXECUTABLE:FILEPATH=$QT_DIR_IOS/bin/qmake \
    -DCMAKE_PREFIX_PATH:PATH=$QT_DIR_IOS \
    -DCMAKE_OSX_ARCHITECTURES:STRING=arm64 \
    -DCMAKE_OSX_SYSROOT:STRING=iphoneos \
    -DQT_HOST_PATH=$QT_DIR \
    -DOPENTODOLIST_APPLE_TEAM_ID="$IOS_TEAM_ID" \
    -DOPENTODOLIST_APPLE_CODE_SIGN_IDENTITY="$IOS_CODE_SIGN_IDENTITY" \
    -DOPENTODOLIST_APPLE_CODE_SIGN_STYLE=Manual \
    -DOPENTODOLIST_IOS_PROVISIONING_PROFILE_SPECIFIER="$IOS_PROVISIONING_PROFILE_SPECIFIER"

if [ -n "$CONFIGURE_ONLY" ]; then
    exit 0
fi

# cmake --build . --config Release -- "$XCODEBUILD_FLAGS" ## Leads to "Archive Failed" errors in next step - but we need at least CMake 3.25.0

xcodebuild -scheme OpenTodoList -sdk iphoneos -configuration Release archive -archivePath OpenTodoList.xcarchive
xcodebuild -exportArchive -archivePath OpenTodoList.xcarchive -exportOptionsPlist "$EXPORT_OPTIONS_PLIST" -exportPath OpenTodoList.ipa
