FROM linuxserver/ffmpeg
ENV DAYS=30
ENV VIDEO_SEGMENT_TIME=300
ENV VIDEO_FORMAT=mp4
RUN apt-get update && apt-get install -y cron
VOLUME [ "/var/recordings" ]
COPY resources /
ENTRYPOINT ["/docker-entrypoint.sh"]
