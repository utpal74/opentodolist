$ErrorActionPreference = "Stop"

function Invoke-NativeCommand {
    param(
        [Parameter(Mandatory=$true)]
        [string]$FilePath,
        [Parameter(ValueFromRemainingArguments=$true)]
        [string[]]$Arguments
    )

    Write-Output "Running: $FilePath $Arguments"
    & $FilePath @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "Command failed with exit code ${LASTEXITCODE}: $FilePath $Arguments"
    }
}

function Assert-PathExists {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Path,
        [Parameter(Mandatory=$true)]
        [string]$Message
    )

    if (-Not (Test-Path -Path $Path)) {
        throw $Message
    }
}

function Assert-CommandExists {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Command,
        [Parameter(Mandatory=$true)]
        [string]$Message
    )

    if (-Not (Get-Command $Command -ErrorAction SilentlyContinue)) {
        throw $Message
    }
}

function Install-ChocolateyPackage {
    param(
        [Parameter(Mandatory=$true)]
        [string]$PackageName,
        [Parameter(Mandatory=$true)]
        [string]$ValidationPath
    )

    if (Test-Path -Path $ValidationPath) {
        return
    }

    for ($attempt = 1; $attempt -le 3; $attempt++) {
        Write-Output "Installing $PackageName via Chocolatey (attempt $attempt of 3)"
        choco install -y --no-progress $PackageName
        if (($LASTEXITCODE -eq 0) -and (Test-Path -Path $ValidationPath)) {
            return
        }
        Write-Warning "Installation of $PackageName failed or did not create $ValidationPath."
        Start-Sleep -Seconds (10 * $attempt)
    }

    throw "Failed to install $PackageName or installation did not create $ValidationPath."
}

function Install-Qt {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ArchiveUrl,
        [Parameter(Mandatory=$true)]
        [string]$ArchivePath,
        [Parameter(Mandatory=$true)]
        [string]$DestinationPath
    )

    if (Test-Path -Path $ArchivePath) {
        Remove-Item -Path $ArchivePath -Force
    }

    New-Item -Path $DestinationPath -ItemType Directory -Force | Out-Null

    for ($attempt = 1; $attempt -le 3; $attempt++) {
        Write-Output "Downloading Qt archive (attempt $attempt of 3)"
        try {
            Invoke-WebRequest -Uri $ArchiveUrl -OutFile $ArchivePath -UseBasicParsing -ErrorAction Stop
            Add-Type -AssemblyName System.IO.Compression.FileSystem
            $zip = [System.IO.Compression.ZipFile]::OpenRead((Resolve-Path $ArchivePath))
            $zip.Dispose()
            Expand-Archive -Path $ArchivePath -DestinationPath $DestinationPath -Force -ErrorAction Stop
            return
        } catch {
            Write-Warning "Failed to download or unpack Qt: $($_.Exception.Message)"
            if (Test-Path -Path $ArchivePath) {
                Remove-Item -Path $ArchivePath -Force
            }
            Start-Sleep -Seconds (15 * $attempt)
        }
    }

    throw "Failed to download and unpack Qt from $ArchiveUrl."
}

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
    Install-Qt -ArchiveUrl $QT_ARCHIVE_URL -ArchivePath "Qt-mingw-w64.zip" -DestinationPath $qt_root
}

# Install Strawberry Perl (needed for KDE Syntax Highlighting) and NSIS installer framework:
Install-ChocolateyPackage -PackageName "strawberryperl" -ValidationPath $PERL_PATH
Install-ChocolateyPackage -PackageName "nsis" -ValidationPath $NSIS_PATH

# Setup search paths (important - order matters!):
$env:Path="$QT_PATH\bin;$CMAKE_PATH;$NINJA_PATH;$MINGW_PATH;$PERL_PATH;$NSIS_PATH;$env:Path"

Assert-PathExists -Path "$QT_PATH\bin" -Message "Qt bin directory not found in $QT_PATH."
Assert-PathExists -Path "$MINGW_PATH\clang++.exe" -Message "LLVM MinGW compiler not found in $MINGW_PATH."
Assert-CommandExists -Command "cmake" -Message "CMake not found in PATH."
Assert-CommandExists -Command "ninja" -Message "Ninja not found in PATH."
Assert-CommandExists -Command "perl" -Message "Perl not found in PATH."
Assert-CommandExists -Command "makensis" -Message "NSIS makensis not found in PATH."
Assert-CommandExists -Command "windeployqt" -Message "windeployqt not found in PATH."

# Build OpenTodoList:
Invoke-NativeCommand cmake `
    -S . -B build-win64 `
    -GNinja `
    -DCMAKE_PREFIX_PATH=$QT_PATH `
    -DCMAKE_INSTALL_PREFIX=deploy-win64 `
    -DOPENTODOLIST_WITH_UPDATE_SERVICE=ON `
    --fresh

Invoke-NativeCommand cmake --build build-win64 --target OpenTodoList
Invoke-NativeCommand cmake --install build-win64
Invoke-NativeCommand windeployqt --qmldir src deploy-win64\bin

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

Invoke-NativeCommand makensis win64-installer.nsis

Rename-Item OpenTodoList-Windows-64bit.exe OpenTodoList-$OPENTODOLIST_VERSION-Windows-64bit.exe

# Check if the build was successful. Sometimes, installations fail, but
# it seems we get no indication in the form of a non-zero return code.
# In this case, as a last resort, check if we were able to build
# our desired deployables and - if not - error out.
if(-Not (Test-Path -Path "OpenTodoList-$OPENTODOLIST_VERSION-Windows-64bit.zip")) {
    throw "No portable OpenTodoList found - the build probably failed!"
}
if(-Not (Test-Path -Path "OpenTodoList-$OPENTODOLIST_VERSION-Windows-64bit.exe")) {
    throw "No OpenTodoList installer found - the build probably failed!"
}
