#!/bin/bash
set -e

DIRECTORY="/var/recordings/$CAMERA_NAME"
mkdir -p "$DIRECTORY"

echo "Parameters:"
echo "  TZ: $TZ"
echo "  STREAM_URL: $STREAM_URL"
echo "  CAMERA_NAME: $CAMERA_NAME"
echo "  CONCATENATE: $1"
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

echo "#!/bin/bash" >"/etc/cron.nvr/1-concatenate"
chmod +x "/etc/cron.nvr/1-concatenate"
if [ ! -z "$CONCATENATE" ]; then
    CRON=1
    echo "[CRON] Concatenate daily recorded files..."
    echo "/opt/nvr/concatenate.sh \"$DIRECTORY\" $VIDEO_FORMAT \$(date -d 'yesterday' '+%Y-%m-%d')" >>"/etc/cron.nvr/1-concatenate"
fi

echo "#!/bin/bash" >"/etc/cron.nvr/2-cleanup"
chmod +x "/etc/cron.nvr/2-cleanup"
if [ ! -z "$DAYS" ]; then
    CRON=1
    echo "[CRON] Clean up recordings older than $DAYS days..."
    echo "/opt/nvr/cleanup.sh \"$DIRECTORY\" $DAYS" >>"/etc/cron.nvr/2-cleanup"
fi

if [ ! -z "$CRON" ]; then
    service cron start
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
