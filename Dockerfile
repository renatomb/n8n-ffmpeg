ARG BASE_TAG=latest

# Stage 1: Get ffmpeg from Alpine
FROM alpine:3.22 AS ffmpeg-builder
RUN apk add --no-cache ffmpeg

# Stage 2: Final image
FROM n8nio/n8n:${BASE_TAG}
LABEL org.opencontainers.image.title="n8n-ffmpeg" \
      org.opencontainers.image.description="n8n (Alpine) with FFmpeg" \
      org.opencontainers.image.url="https://hub.docker.com/r/renatomb/n8n-ffmpeg" \
      org.opencontainers.image.source="https://github.com/renatomb/n8n-ffmpeg" \
      org.opencontainers.image.authors="Renato Monteiro Batista <https://github.com/renatomb>" \
      org.opencontainers.image.licenses="Apache-2.0"

USER root
# Copy ffmpeg and its dependencies from Alpine
COPY --from=ffmpeg-builder /usr/bin/ffmpeg /usr/bin/ffmpeg
COPY --from=ffmpeg-builder /usr/bin/ffprobe /usr/bin/ffprobe
COPY --from=ffmpeg-builder /usr/lib /usr/lib

EXPOSE 5678
USER node
