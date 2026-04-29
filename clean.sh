#!/bin/bash
# Clean the Buildroot build directory.
# Run from the repository root.
set -e
cd "$(dirname "$0")"
if [ ! -d buildroot ]; then
    echo "Error: buildroot directory not found in $(pwd)" >&2
    exit 1
fi
make -C buildroot distclean
