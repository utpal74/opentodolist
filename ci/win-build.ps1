$ErrorActionPreference = "Stop"

if(-not $env:QT_INSTALL_ROOT) {
    $qt_root = "C:\Qt"
} else {
    $qt_root = $env:QT_INSTALL_ROOT
}

if (-not $env:QT_VERSION) {
    $qt_versions = Get-ChildItem "$qt_root" | Where-Object {$_.name -like "*.*.*"} | Select-Object name | Sort-Object { $_ -as [version] }
    $env:QT_VERSION = $qt_versions[0].Name
}

# Expected paths:
$CMAKE_PATH="$qt_root\Tools\CMake_64\bin"
$NINJA_PATH="$qt_root\Tools\Ninja"
$MINGW_PATH="$qt_root\Tools\llvm-mingw1706_64\bin\"
$QT_PATH="$qt_root\$env:QT_VERSION\llvm-mingw_64\"
$PERL_PATH="C:\Strawberry\perl\bin"
$NSIS_PATH="C:\Program Files (x86)\NSIS"

# Configuration:
$QT_ARCHIVE_URL="https://gitlab.com/api/v4/projects/46171955/packages/generic/Qt6/$env:QT_VERSION/Qt-llvm-mingw-w64.zip"


if(-Not (Test-Path -Path "$QT_PATH")) {
    # Install Qt
    Write-Output "Qt installation not found in $QT_PATH - downloading and installing Qt $env:QT_VERSION"
    Invoke-WebRequest -o "Qt-mingw-w64.zip" $QT_ARCHIVE_URL
    New-Item -Path '$qt_root' -ItemType Directory
    Expand-Archive -Path "Qt-mingw-w64.zip" -DestinationPath "$qt_root"
}

if(-Not (Test-Path -Path "$PERL_PATH")) {
    # Install Strawberry Perl (needed for KDE Syntax Highlighting)
    choco install -y strawberryperl

    if (-not $?) {
        Write-Error -Message "Failed to install Perl."
    }
    if(-Not (Test-Path -Path "$PERL_PATH")) {
        Write-Error -Message "Installation of Perl did not yield desired installation folder."
    }
}

if(-Not (Test-Path -Path "$NSIS_PATH")) {
    # Install NSIS installer framework:
    choco install -y nsis

    if (-not $?) {
        Write-Error -Message "Failed to install NSIS."
    }
    if(-Not (Test-Path -Path "$PERL_PATH")) {
        Write-Error -Message "Installation of NSIS did not yield desired installation folder."
    }
}

# Setup search paths (important - order matters!):
$env:Path="$QT_PATH\bin;$CMAKE_PATH;$NINJA_PATH;$MINGW_PATH;$PERL_PATH;$NSIS_PATH;$env:Path"

# Build OpenTodoList:
cmake `
    -S . -B build-win64 `
    -GNinja `
    -DCMAKE_PREFIX_PATH=$QT_PATH `
    -DCMAKE_INSTALL_PREFIX=deploy-win64 `
    -DOPENTODOLIST_WITH_UPDATE_SERVICE=ON `
    --fresh

if (-not $?) {
    Write-Error -Message "Failed to configure OpenTodoList."
}

cmake --build build-win64 --target OpenTodoList

if (-not $?) {
    Write-Error -Message "Failed to build OpenTodoList."
}

cmake --install build-win64

if (-not $?) {
    Write-Error -Message "Failed to install OpenTodoList."
}

windeployqt --qmldir src deploy-win64\bin

if (-not $?) {
    Write-Error -Message "Failed to deploy Qt binaries for OpenTodoList."
}

Copy-Item -Path "$MINGW_PATH/libc++.dll" -Destination deploy-win64\bin
Copy-Item -Path "$MINGW_PATH/libunwind.dll" -Destination deploy-win64\bin

# Prepare portable version of the app:
$OPENTODOLIST_VERSION = git describe --tags
Remove-Item -Path OpenTodoList-$OPENTODOLIST_VERSION-Windows-64bit -Recurse -ErrorAction Ignore
New-Item -Type Directory -Path OpenTodoList-$OPENTODOLIST_VERSION-Windows-64bit
Copy-Item -Path deploy-win64\bin\* -Destination .\OpenTodoList-$OPENTODOLIST_VERSION-Windows-64bit\ -Recurse
Compress-Archive `
    -Path .\OpenTodoList-$OPENTODOLIST_VERSION-Windows-64bit `
    -DestinationPath deploy-win64\OpenTodoList-$OPENTODOLIST_VERSION-Windows-64bit.zip

# Copy NSIS config and build installer:
Copy-Item -Path templates\nsis\win64-installer.nsis -Destination deploy-win64

Set-Location -Path deploy-win64

makensis win64-installer.nsis

if (-not $?) {
    Write-Error -Message "Failed to create installer."
}

Rename-Item OpenTodoList-Windows-64bit.exe OpenTodoList-$OPENTODOLIST_VERSION-Windows-64bit.exe

# Check if the build was successful. Sometimes, installations fail, but
# it seems we get no indication in the form of a non-zero return code.
# In this case, as a last resort, check if we were able to build
# our desired deployables and - if not - error out.
if(-Not (Test-Path -Path "OpenTodoList-$OPENTODOLIST_VERSION-Windows-64bit.zip")) {
    Write-Error -Message "No portable OpenTodoList found - the build probably failed!"
}
if(-Not (Test-Path -Path "OpenTodoList-$OPENTODOLIST_VERSION-Windows-64bit.exe")) {
    Write-Error -Message "No OpenTodoList installer found - the build probably failed!"
}
