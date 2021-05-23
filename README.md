# rtorrent

Custom Docker image for rTorrent.

## Build Docker image

```
docker build -t rtorrent:latest .
```

## Run

The container:

- Comes with ruTorrent frontend configured, to use it just bind any port (eg: 8080) to :80 inside the container.
- Is configured to add and start torrents from `/home/rtorrent/rtorrent/watch/start`, to use this functionality make a bind mount.

Example:

```
DOWNLOAD_DIR=$(pwd)/download
WATCH_DIR=$(pwd)/watch
RUTORRENT_PORT=8080

docker run --rm -it \
    -v ${WATCH_DIR}:/home/rtorrent/rtorrent/watch/start \
    -v ${DOWNLOAD_DIR}:/home/rtorrent/rtorrent/download \
    -p ${RUTORRENT_PORT}:80 \
    rtorrent
```
