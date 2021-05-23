#/bin/bash

USER=rtorrent
TIMEOUT=30
SLEEP_TIME=5
RTORRENT_SOCK_PATH=/home/${USER}/rtorrent/.session/rpc.socket
LOG_FILES="
/var/log/lighttpd/access.log
/var/log/lighttpd/error.log
/home/${USER}/rtorrent/log/xmlrpc.log
/home/${USER}/rtorrent/log/execute.log
"

chmod 777 -R /home/${USER}/rtorrent

echo

RTORRENT_TIMEOUT=${TIMEOUT}
su - ${USER} -c rtorrent &
while true; do
    echo Starting rTorrent - timeout ${RTORRENT_TIMEOUT}s

    if [ -e ${RTORRENT_SOCK_PATH} ]; then
        break
    fi

    if [ "$RTORRENT_TIMEOUT" == 0 ]; then
        echo "ERROR: Timeout while waiting"
        exit 1
    fi

    RTORRENT_TIMEOUT=$(expr ${RTORRENT_TIMEOUT} - ${SLEEP_TIME})
    sleep ${SLEEP_TIME}
done

LIGHTTPD_TIMEOUT=${TIMEOUT}
lighttpd -f /etc/lighttpd/lighttpd.conf &
while true; do
    echo Starting ruTorrent - timeout ${LIGHTTPD_TIMEOUT}s

    LIGHTTPD_STATUS=$(curl -Is http://localhost | head -1)
    if [[ "${LIGHTTPD_STATUS}" == *"200 OK"* ]]; then
        break
    fi

    if [ "$LIGHTTPD_TIMEOUT" == 0 ]; then
        echo "ERROR: Timeout while waiting"
        exit 1
    fi

    LIGHTTPD_TIMEOUT=$(expr ${LIGHTTPD_TIMEOUT} - ${SLEEP_TIME})
    sleep ${SLEEP_TIME}
done

RAPI_TIMEOUT=${TIMEOUT}
su - ${USER} -c /home/${USER}/rapi/rapi &
while true; do
    echo Starting rAPI - timeout ${RAPI_TIMEOUT}s

    RAPI_STATUS=$(curl -Is http://localhost:9090 | head -1)
    if [[ "${RAPI_STATUS}" == *"404"* ]]; then
        break
    fi

    if [ "$RAPI_TIMEOUT" == 0 ]; then
        echo "ERROR: Timeout while waiting"
        exit 1
    fi

    RAPI_TIMEOUT=$(expr ${RAPI_TIMEOUT} - ${SLEEP_TIME})
    sleep ${SLEEP_TIME}
done

for log in ${LOG_FILES}; do
    tail -F ${log} &
done

tail -f /dev/null
