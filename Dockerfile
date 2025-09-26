ARG BASE_TAG=latest
FROM n8nio/n8n:${BASE_TAG}
LABEL org.opencontainers.image.title="n8n-ffmpeg" \
      org.opencontainers.image.description="n8n (Alpine) with FFmpeg" \
      org.opencontainers.image.url="https://hub.docker.com/r/renatomb/n8n-ffmpeg" \
      org.opencontainers.image.source="https://github.com/renatomb/n8n-ffmpeg" \
      org.opencontainers.image.authors="Renato Monteiro Batista <https://github.com/renatomb>" \
      org.opencontainers.image.licenses="Apache-2.0"
USER root
RUN apk add --no-cache ffmpeg
EXPOSE 5678
USER node
