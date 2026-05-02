#!/bin/bash

set -e

# Install secrets when running in CI:
. ci/apple/get-secrets.sh

# Install Qt in CI if needed
export QT_INSTALL_IOS="1"
bash ci/apple/macos-install-qt.sh

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
                if ! "$tool_path" -h >/dev/null; then
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
if [ -n "$HOST_CMAKE" ]; then
    CMAKE_BIN=$HOST_CMAKE
else
    CMAKE_BIN=cmake
    export PATH=$QT_INSTALLATION_DIR/Tools/CMake/CMake.app/Contents/bin:$PATH
fi

echo "Using CMake: $CMAKE_BIN"
file "$CMAKE_BIN"


# The iOS build is currently a bit unstable... as setting up the environment
# is quite costly, we rather retry the actual build several times (cleaning up
# in between) rather than giving up immediately.
i=0
while [[ $i -lt 5 ]]
do
    ((i++))
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
        -DQT_HOST_PATH=$QT_DIR

    if [ -n "$CONFIGURE_ONLY" ]; then
        exit 0
    fi

    # cmake --build . --config Release -- "$XCODEBUILD_FLAGS" ## Leads to "Archive Failed" errors in next step - but we need at least CMake 3.25.0

    if xcodebuild -scheme OpenTodoList -sdk iphoneos -configuration Release archive -archivePath OpenTodoList.xcarchive -allowProvisioningUpdates && \
        xcodebuild -exportArchive -archivePath OpenTodoList.xcarchive -exportOptionsPlist ../src/ExportOptions.plist -exportPath OpenTodoList.ipa -allowProvisioningUpdates; then
        exit 0
    else
        echo "Build attempt $i failed"
    fi
    cd ..
done

# Still here? Then we didn't get a succesful build!
exit 1
