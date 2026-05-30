#!/bin/bash

set -e

# Install secrets when running in CI:
. ci/apple/get-secrets.sh

# Install Qt in CI if needed
bash ci/apple/macos-install-qt.sh

# Install CMake/Ninja in CI:
. ci/apple/install-build-tools.sh

BUILD_DIR=$PWD/build-macos

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

if [ -z "$MACOS_TEAM_ID" ]; then
    # Default Team ID to use:
    MACOS_TEAM_ID="786Z636JV9"
fi
if [ -z "$MACOS_CODE_SIGN_IDENTITY" ]; then
    MACOS_CODE_SIGN_IDENTITY="Developer ID Application: Martin Hoeher ($MACOS_TEAM_ID)"
fi

echo "Using macOS code signing identity: $MACOS_CODE_SIGN_IDENTITY"
security find-identity -v -p codesigning || true
if ! security find-identity -v -p codesigning | grep -F "$MACOS_CODE_SIGN_IDENTITY"; then
    echo "The macOS code signing identity was not found: $MACOS_CODE_SIGN_IDENTITY"
    exit 1
fi

export QT_DIR=$QT_INSTALLATION_DIR/$QT_VERSION/macos

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

run_qt_tool_smoke_tests "$QT_DIR" macos


#rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR
cd $BUILD_DIR

HOST_CMAKE=$(command -v cmake || true)
HOST_NINJA=$(command -v ninja || true)
if [ -z "$HOST_CMAKE" ] || [ -z "$HOST_NINJA" ]; then
    echo "CMake and Ninja are required"
    exit 1
fi
CMAKE_BIN=$HOST_CMAKE
export PATH="$(dirname "$HOST_NINJA"):$PATH"
RESOLVED_CMAKE_BIN=$(command -v "$CMAKE_BIN")

ls $QT_DIR/bin
file $QT_DIR/bin/qt-cmake
echo "Using CMake: $CMAKE_BIN"
echo "Resolved CMake: $RESOLVED_CMAKE_BIN"
file "$RESOLVED_CMAKE_BIN"
codesign --verify --verbose=2 "$RESOLVED_CMAKE_BIN" || true
echo "Using Ninja: $(command -v ninja)"
file "$(command -v ninja)"
df -h

"$CMAKE_BIN" \
    -GNinja \
    -DCMAKE_TOOLCHAIN_FILE=$QT_DIR/lib/cmake/Qt6/qt.toolchain.cmake \
    -DCMAKE_PREFIX_PATH=$QT_DIR \
    -DCMAKE_BUILD_TYPE=Release \
    -DOPENTODOLIST_WITH_UPDATE_SERVICE=ON \
    -DCMAKE_OSX_ARCHITECTURES="x86_64;arm64" \
    --fresh \
    ..
"$CMAKE_BIN" --build .
# TODO: Tests on macos currently fail sometimes - this probably is a race condition that we should urgently fix!
# For now, try up to 3 times to repeat.
"$CMAKE_BIN" --build . --target test || "$CMAKE_BIN" --build . --target test || "$CMAKE_BIN" --build . --target test


###########################################
# Create app for distribution via website #
###########################################

# Include Qt Runtime in App Bundle. Also sign the bundle
# and prepare it for notarization:
rm -rf dist-web

for i in initial retry; do
    mkdir -p dist-web
    cp -r src/OpenTodoList.app dist-web
    pushd dist-web
    $QT_DIR/bin/macdeployqt \
        OpenTodoList.app/ \
        -qmldir=../../src \
        -appstore-compliant \
        -sign-for-notarization="$MACOS_CODE_SIGN_IDENTITY"
    find OpenTodoList.app -name "*.dSYM" -type d | xargs rm -rf
    popd

    # Create a zip archive suitable for uploading to the notarization
    # service:
    ditto \
        -ck --rsrc \
        --sequesterRsrc \
        --keepParent \
        "dist-web/OpenTodoList.app" "dist-web/OpenTodoList.zip"

    # Make sure the app has been signed:
    if [ $i == "initial" ]; then
        # On first attempt, if we succeed, leave the loop:
        if codesign -v dist-web/OpenTodoList.app; then
            break
        fi
    else
        # Fail if second attempt failed
        codesign -v dist-web/OpenTodoList.app
    fi
done

# Upload the archive for notarization (see
# https://developer.apple.com/documentation/security/notarizing_macos_software_before_distribution/customizing_the_notarization_workflow
# for details):
xcrun notarytool submit \
    "dist-web/OpenTodoList.zip" \
    --wait \
    --apple-id $APPSTORE_USER \
    --team-id "$MACOS_TEAM_ID" \
    --password $APPSTORE_PASSWORD

# Include the notarization ticket in the app bundle:
xcrun stapler staple "dist-web/OpenTodoList.app"

# Prepare a "beautified" folder:
cd dist-web
mkdir dmg.in
cp -R OpenTodoList.app dmg.in
cp ../../templates/macos/DS_Store ./dmg.in/.DS_Store
cd dmg.in
ln -s /Applications ./Applications
cd ../

# Create DMG file:
i="0"
while [ $i -lt 5 ]; do
    if ! hdiutil create \
        -volname OpenTodoList \
        -srcfolder ./dmg.in \
        -ov -format UDZO \
        OpenTodoList.dmg; then
        echo "Creating disk image failed - retrying in 30s"
        sleep 30
    else
        break
    fi
    i=$[$i+1]
done

cd ..
cp dist-web/OpenTodoList.dmg src/


#################################################
# Create Package for Distribution via App Store #
#################################################

# Currently, this is not working - skip here
exit 0

mkdir -p dist-store
cp -r src/OpenTodoList.app dist-store

pushd dist-store
$QT_DIR/bin/macdeployqt \
    OpenTodoList.app/ \
    -qmldir=../../src \
    -appstore-compliant \
    -sign-for-notarization="Apple Distribution: Martin Hoeher (786Z636JV9)"
find OpenTodoList.app -name "*.dSYM" -type d | xargs rm -rf
popd
xcrun codesign \
    -s "Apple Distribution: Martin Hoeher (786Z636JV9)" \
    -v -f \
    -o runtime \
    --entitlements ../src/OpenTodoList.entitlements \
    "dist-store/OpenTodoList.app"

# Upload the App Bundle:
xcrun productbuild --component "dist-store/OpenTodoList.app" /Applications "dist-store/OpenTodoList.pkg"
xcrun productsign \
    --sign "3rd Party Mac Developer Installer: Martin Hoeher (786Z636JV9)" \
    "dist-store/OpenTodoList.pkg" \
    "dist-store/OpenTodoList-signed.pkg"
xcrun altool --validate-app \
    -f "dist-store/OpenTodoList-signed.pkg" \
    -t macos \
    -u $APPSTORE_USER \
    -p $APPSTORE_PASSWORD
