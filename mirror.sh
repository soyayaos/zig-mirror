#!/bin/bash

set -e

INDEX="index.json"
FIRST_URL=true

rm -f "$INDEX"
curl -s "https://ziglang.org/download/index.json" -o "$INDEX"

for URL in $(cat index.json | jq -r '.. | .tarball? | select(. != null)'); do
    echo "url: $URL"
    FILE=$(echo "$URL" | cut -d'/' -f4-)
    echo "file: $FILE"
    if [ ! -f "$FILE" ]; then
      if [ "$FIRST_URL" = true ]; then
        rm -rf builds
        FIRST_URL=false
      fi
      DIR=$(echo "$URL" | cut -d'/' -f4- | rev | cut -d'/' -f2- | rev)
      echo "dir: $DIR"
      mkdir -p "$DIR"
      echo "downloading ..."
      curl -s "$URL" -o "$FILE"
    fi
    echo
done
