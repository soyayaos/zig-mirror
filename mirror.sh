#!/bin/bash

set -e

INDEX="index.json"

rm -f "$INDEX"
curl -s "https://ziglang.org/download/index.json" -o "$INDEX"

rm -rf builds

for URL in $(cat index.json | jq -r '.. | .tarball? | select(. != null)'); do
    echo "url: $URL"
    FILE=$(echo "$URL" | cut -d'/' -f4-)
    echo "file: $FILE"
    if [ ! -f "$FILE" ]; then
      DIR=$(echo "$URL" | cut -d'/' -f4- | rev | cut -d'/' -f2- | rev)
      echo "dir: $DIR"
      mkdir -p "$DIR"
      echo "downloading ..."
      curl -s "$URL" -o "$FILE"
    fi
    echo
done
