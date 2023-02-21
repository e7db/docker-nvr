#!/bin/bash
DIRECTORY="$1"
DAYS=$2
find "$DIRECTORY" -type f -mtime +$DAYS -delete
