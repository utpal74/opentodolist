#!/bin/bash

set -e

if [ -z "$CI" ]; then
    return 0 2>/dev/null || exit 0
fi

if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew is required to install macOS build tools"
    exit 1
fi

brew list cmake >/dev/null 2>&1 || brew install cmake
brew list ninja >/dev/null 2>&1 || brew install ninja

export PATH="$(brew --prefix)/bin:$PATH"
