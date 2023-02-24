#!/bin/bash
set -e

if [ -z "$STREAM_URL" ]; then
    echo "STREAM_URL needs to bet set. Exiting..."
    exit 1
fi
if [ -z "$CAMERA_NAME" ]; then
    echo "CAMERA_NAME needs to bet set. Exiting..."
    exit 1
fi

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

echo "[CRON] Concatenate daily recorded files..."
echo "#!/bin/bash" >"/etc/cron.nvr/1-concatenate"
echo "/opt/nvr/concatenate.sh "$CAMERA_NAME" \$(date -d 'yesterday' '+%Y-%m-%d')" $VIDEO_FORMAT >>"/etc/cron.nvr/1-concatenate"
chmod +x "/etc/cron.nvr/1-concatenate"

if [ ! -z "$DAYS" ]; then
    echo "[CRON] Clean up recordings older than $DAYS days..."
    echo "#!/bin/bash" >"/etc/cron.nvr/2-cleanup"
    echo "/opt/nvr/cleanup.sh "$CAMERA_NAME" $DAYS" >>"/etc/cron.nvr/2-cleanup"
    chmod +x "/etc/cron.nvr/2-cleanup"
fi

service cron start

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
    "$DIRECTORY"/%Y-%m-%d_%H-%M-%S.ts \
    -loglevel panic
