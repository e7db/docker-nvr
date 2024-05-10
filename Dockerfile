FROM linuxserver/ffmpeg
ENV DAYS=30
ENV LOGLEVEL=info
ENV VIDEO_SEGMENT_TIME=300
ENV VIDEO_FORMAT=mp4
RUN apt-get update && apt-get install -y cron
RUN mkdir /etc/cron.nvr
VOLUME [ "/var/recordings" ]
COPY resources /
ENTRYPOINT ["/docker-entrypoint.sh"]
