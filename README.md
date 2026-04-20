# n8n-ffmpeg

![Docker Pulls](https://img.shields.io/docker/pulls/renatomb/n8n-ffmpeg?logo=docker)
![Docker Image Size](https://img.shields.io/docker/image-size/renatomb/n8n-ffmpeg/latest?logo=docker)
![Build](https://github.com/renatomb/n8n-ffmpeg/actions/workflows/docker-publish.yml/badge.svg)
![GitHub Repo stars](https://img.shields.io/github/stars/renatomb/n8n-ffmpeg?logo=github)

Docker image baseada na [imagem oficial do n8n](https://hub.docker.com/r/n8nio/n8n), com suporte adicional ao **FFmpeg**.  
Ideal para fluxos de automação no n8n que envolvem manipulação de áudio e vídeo.

---

# n8n-ffmpeg (English)

Docker image based on the [official n8n image](https://hub.docker.com/r/n8nio/n8n), with **FFmpeg** support.  
Perfect for automation workflows in n8n that involve audio and video processing.

## 🚀 Included

- Latest stable **n8n**
- **FFmpeg** installed via `apk` (Alpine base)

## 📦 Docker Usage

### Local build

```bash
docker build -t renatomb/n8n-ffmpeg .
docker run --rm -it -p 5678:5678 renatomb/n8n-ffmpeg
```

### With Docker Compose

```yaml
services:
  n8n:
    image: renatomb/n8n-ffmpeg:latest
    ports:
      - "5678:5678"
    volumes:
      - n8n_data:/home/node/.n8n
    environment:
      - N8N_HOST=localhost
      - N8N_PORT=5678
      - N8N_PROTOCOL=http
      - WEBHOOK_URL=http://localhost:5678/
volumes:
  n8n_data:
```

Access: [http://localhost:5678](http://localhost:5678)

## 🌍 Multi-arch
Built and published for **amd64** and **arm64** (runs on x86_64 servers and ARM devices like Raspberry Pi).

## 📜 License
This project follows the [n8n license](https://github.com/n8n-io/n8n/blob/master/LICENSE.md) and only adds FFmpeg support.

---

## n8n ffmpeg usage instructions - merge multiple videos from URL example

This example demonstrates how to merge multiple video files from URLs into a single video using n8n and FFmpeg. Considering that the video files are in MP4 format and have the same codec and resolution. In this example we assume that we have a `/data` folder mounted as a volume in the n8n container to store temporary files.

1. Create a new workflow in n8n.
2. Add a "HTTP Request" node to download a video file, choose "GET" method and provide the video URL, Options - Response Format: File.
3. Add a "Read / Write files From Disk" node to read the downloaded file, set Operation to "Write file to disk", File and path name: `/data/part_{{$itemIndex}}.mp4`.
4. Add a "Execute command node" to generate a text file with the list of videos to merge, set Command to:

```bash
for f in /data/part_*.mp4; do echo "file '$f'" >> /data/list.txt; done
```

or

```bash
ls -1v /data/part*.mp4 | awk '{print "file \x27" $0 "\x27"}' > /data/list.txt
```

5. Add another "Execute command" node to merge the videos using FFmpeg, set Command to:

```bash
ffmpeg -f concat -safe 0 -i /data/list.txt -c copy /data/output.mp4
```

6. Add a final "Read / Write files From Disk" node to read the merged video file, set Operation to "Read file from disk", File path: `/data/output.mp4`.