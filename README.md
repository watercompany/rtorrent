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
WATCH_DIR=$(pwd)/watch
RUTORRENT_PORT=8080

docker run --rm -it \
    -v ${WATCH_DIR}:/home/rtorrent/rtorrent/watch/start \
    -p ${RUTORRENT_PORT}:80 \
    rtorrent
```
