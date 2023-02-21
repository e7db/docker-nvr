#!/bin/bash
DAY=$1
DIRECTORY="/var/recordings/$CAMERA_NAME"
cd "$DIRECTORY"
ffmpeg -y -f concat -safe 0 -i <(find "$DIRECTORY" -name "${DAY}_*.ts" -printf "file '%p'\n" | sort -n) -c copy $DAY.ts
ffmpeg -y -i $DAY.ts -c copy $DAY.$VIDEO_FORMAT
rm ${DAY}_*.ts
