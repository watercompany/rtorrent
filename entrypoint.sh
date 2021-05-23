#/bin/ash

USER=rtorrent

chmod 777 -R /home/${USER}/rtorrent

su - ${USER} -c rtorrent &
sleep 5
lighttpd -f /etc/lighttpd/lighttpd.conf &
sleep 5
su - ${USER} -c /home/${USER}/rapi/rapi &

tail -F /var/log/lighttpd/access.log &
tail -F /var/log/lighttpd/error.log &
tail -F /home/rtorrent/rtorrent/log/xmlrpc.log &
tail -F /home/rtorrent/rtorrent/log/execute.log
