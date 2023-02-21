#!/bin/bash
find "/var/recordings/$CAMERA_NAME" -type f -mtime +$DAYS -delete
