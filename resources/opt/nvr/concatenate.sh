#!/bin/bash
DIRECTORY="$1"
VIDEO_FORMAT=$2
DAY=$3
find "$DIRECTORY" -name "$DAY*.$VIDEO_FORMAT" -exec echo "file '{}'" >>"$DIRECTORY/$DAY-files.txt" \;
ffmpeg -f concat -safe 0 -i "$DIRECTORY/$DAY-files.txt" -c copy "$DIRECTORY/$DAY.mp4"
rm "$DIRECTORY/$DAY*.$VIDEO_FORMAT"
rm "$DIRECTORY/$DAY-files.txt"
