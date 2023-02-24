#!/bin/bash
CAMERA_NAME=$1
DAYS=$2
find "/var/recordings/$CAMERA_NAME" -type f -mtime +$DAYS -delete
