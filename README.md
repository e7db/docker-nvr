# docker-nvr

A [docker container](https://hub.docker.com/r/e7db/nvr) to record any IP camera stream to disk.

## Usage

### Docker run

```
docker run -it --rm  --name nvr \
  -v /path/to/local/recordings:/var/recordings \
  -e STREAM_URL="rtsp://username:password@ip:port/path" \
  -e CAMERA_NAME="My Camera" \
  e7db/nvr
```

### Docker Compose

```
services:
  camera-1:
    image: e7db/nvr
    environment:
      - TZ=America/Chicago
      - STREAM_URL="rtsp://username:password@ip:port/path"
      - CAMERA_NAME="Chicago Office"
    volumes:
      - /path/to/local/recordings:/var/recordings
  camera2:
    image: e7db/nvr
    environment:
      - TZ=America/New_York
      - DAYS=30
      - STREAM_URL="rtsp://username:password@ip:port/path"
      - CAMERA_NAME="New York Warehouse"
      - VIDEO_SEGMENT_TIME=60
      - VIDEO_FORMAT=flv
    volumes:
      - /path/to/local/recordings:/var/recordings
```


### Parameters

Find below a table listing all the different parameters you can use with the container,through the environment variables.
| Variable             | Default       | Description |
| :-                   | :-            | :- |
| `TZ `                | UTC           | The time zone for file names date and time. |
| `STREAM_URL`         |               | The URL to your camera feed. |
| `CAMERA_NAME`        |               | The name used to create your camera recordings folder. |
| `CONCATENATE`        | 1             | Assemble video segments into a daily video. Enabled if not empty. |
| `DAYS`               |               | The days of recording to keep for the camera. An empty value means no limit. |
| `VIDEO_SEGMENT_TIME` | 300           | The length in seconds of each recording file. |
| `VIDEO_FORMAT`       | mp4           | The output video format. You can use any ffmpeg supported format. Recommended value: `mp4`, `flv` or `mkv`. |

By default, 5 minutes segments of MP4 video files will be created, named following the UTC time zone.

### Stream URL

To determine the `STREAM_URL` of your camera, refer to its documentation. You may also find it in its web interface or companion app. You can also try and determine it with the [iSpy Camera Connection Database](https://www.ispyconnect.com/cameras).

Generally, your camera stream URL would take the form of a RSTP URL with authentication:
`rstp://user:password@ip:port/path`

Here is an exemple corresponding to a generic chinese one I have:
`rstp://user:password@192.168.7.98:554/11`

You may also try with different protocols, like RTMP or HTTP.
