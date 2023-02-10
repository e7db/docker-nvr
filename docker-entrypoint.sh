#!/bin/bash
set -e

DIRECTORY="/var/recordings/$CAMERA_NAME"
mkdir -p "$DIRECTORY"

echo "Parameters:"
echo "  TZ: $TZ"
echo "  STREAM_URL: $STREAM_URL"
echo "  CAMERA_NAME: $CAMERA_NAME"
echo "  DAYS: $DAYS"
echo "  VIDEO_SEGMENT_TIME: $VIDEO_SEGMENT_TIME"
echo "  VIDEO_FORMAT: $VIDEO_FORMAT"
echo

if [ -z "$STREAM_URL" ]; then
    echo "STREAM_URL needs to bet set. Exiting..."
    exit 1
fi
if [ -z "$CAMERA_NAME" ]; then
    echo "CAMERA_NAME needs to bet set. Exiting..."
    exit 1
fi

if [ ! -z "$DAYS" ]; then
    echo "#!/bin/sh" > "/etc/cron.daily/nvr-cleanup"
    echo "find $DIRECTORY -type f -mtime +$DAYS -delete" >> "/etc/cron.daily/nvr-cleanup"
    chmod +x "/etc/cron.daily/nvr-cleanup"
    service cron start
    echo
fi

echo "Saving \"$CAMERA_NAME\" camera stream..."
ffmpeg \
    -i "$STREAM_URL" \
    -rtsp_transport tcp \
    -c:v copy \
    -c:a aac \
    -f segment \
    -segment_time "$VIDEO_SEGMENT_TIME" \
    -segment_atclocktime 1 \
    -strftime 1 \
    "$DIRECTORY"/%Y-%m-%d_%H-%M-%S."$VIDEO_FORMAT" \
    -loglevel panic
