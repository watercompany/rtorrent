FROM alpine:3.13

ENV USER=rtorrent
ENV UID=1000
ENV GID=1000
ENV RU_TORRENT_VERSION=v3.10
ENV XMLRPC_VERSION=1.51.07

ADD apk_packages apk_packages
RUN apk add $(cat apk_packages | xargs)

RUN curl -L "http://downloads.sourceforge.net/project/xmlrpc-c/Xmlrpc-c Super Stable/${XMLRPC_VERSION}/xmlrpc-c-${XMLRPC_VERSION}.tgz" > xmlrpc.tar.gz
RUN tar x -zf xmlrpc.tar.gz
RUN cd xmlrpc-c-${XMLRPC_VERSION} && \
    ./configure && \
    make && \
    make install
RUN cd xmlrpc-c-${XMLRPC_VERSION}/tools/xmlrpc && \
    make && \
    make install

ADD mod_fastcgi.conf /etc/lighttpd/mod_fastcgi.conf
ADD lighttpd.conf /etc/lighttpd/lighttpd.conf

RUN addgroup -S ${USER} -g ${GID}
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/home/${USER}" \
    --ingroup "$USER" \
    --no-create-home \
    --uid "$UID" \
    "$USER"

WORKDIR /var/www/localhost/htdocs
RUN git clone https://github.com/Novik/ruTorrent.git .
RUN git checkout ${RU_TORRENT_VERSION}
ADD ruTorrent_config.php /var/www/localhost/htdocs/conf/config.php
RUN chown -R ${USER}:${USER} /var/www/localhost/htdocs
RUN chmod 770 -R /var/www/localhost/htdocs

WORKDIR /home/rtorrent
RUN chown -R ${USER}:${USER} /home/rtorrent
RUN chown -R ${USER}:${USER} /var/log/lighttpd
ADD rtorrent.rc ./.rtorrent.rc
ADD entrypoint.sh entrypoint.sh

ADD rapi rapi
RUN cd rapi && \
    go build -v

EXPOSE 80
EXPOSE 9090
EXPOSE 50000

CMD [ "bash", "/home/rtorrent/entrypoint.sh" ]
