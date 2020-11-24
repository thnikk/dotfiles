#!/bin/bash

DUMP_DIR=${1:-dump}

mkdir -p "$DUMP_DIR"
while IFS= read -r line; do
    DIR="$DUMP_DIR/$(basename "${line%.*}")"
    unzip "$line" -d "$DIR"
done <<< "$(fd zip)"

