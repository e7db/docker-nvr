#!/bin/bash
CAMERA_NAME="$1"
DAY=$2
VIDEO_FORMAT=$3
DIRECTORY="/var/recordings/$CAMERA_NAME"
cd "$DIRECTORY"
ffmpeg -y -f concat -safe 0 -i <(find "$DIRECTORY" -name "${DAY}_*.ts" -printf "file '%p'\n" | sort -n) -c copy $DAY.tmp.ts
ffmpeg -y -i $DAY.tmp.ts -c copy $DAY.$VIDEO_FORMAT
rm -f $DAY.tmp.ts ${DAY}_*.ts
