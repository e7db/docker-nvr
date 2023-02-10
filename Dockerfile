FROM linuxserver/ffmpeg
ENV VIDEO_SEGMENT_TIME=300 \
    VIDEO_FORMAT=mp4
RUN apt-get update && apt-get install -y cron
VOLUME [ "/var/recordings" ]
COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
