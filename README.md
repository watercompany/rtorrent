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
- Has a simple webserver listening on port 9090 hooked to rTorrent's XML-RPC interface that can be used to obtain information about the rTorrent instance.

Example:

```
DOWNLOAD_DIR=$(pwd)/download
WATCH_DIR=$(pwd)/watch
RUTORRENT_PORT=8080
RAPI_PORT=9090

docker run --rm -it \
    -v ${WATCH_DIR}:/home/rtorrent/rtorrent/watch/start \
    -v ${DOWNLOAD_DIR}:/home/rtorrent/rtorrent/download \
    -p ${RUTORRENT_PORT}:80 \
    -p ${RAPI_PORT}:9090 \
    rtorrent
```

### Query information

Just `curl` the port binded to `9090`.

Example:

```
curl -sv localhost:9090 | jq 
*   Trying ::1:9090...
* Connected to localhost (::1) port 9090 (#0)
> GET / HTTP/1.1
> Host: localhost:9090
> User-Agent: curl/7.76.1
> Accept: */*
> 
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Content-Type: application/json; charset=utf-8
< Date: Sun, 23 May 2021 20:38:29 GMT
< Content-Length: 1197
< 
{ [1197 bytes data]
* Connection #0 to host localhost left intact
[
  {
    "Hash": "B3447AF06EAF148C99E3C8FA4F484F8DCA49C5F6",
    "Name": "debian-10.9.0-amd64-DVD-1.iso",
    "Path": "/home/rtorrent/rtorrent/download/debian-10.9.0-amd64-DVD-1.iso",
    "Size": 3972317184,
    "Label": "",
    "Completed": false,
    "Ratio": 0,
    "Created": "2021-03-27T11:59:59Z",
    "Started": "2021-05-23T20:37:50Z",
    "Finished": "1970-01-01T00:00:00Z"
  }
]
```
