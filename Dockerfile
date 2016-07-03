FROM debian:jessie
MAINTAINER David Personette <dperson@gmail.com>

# Install Plex
RUN export DEBIAN_FRONTEND='noninteractive' && \
    export sha256sum='f5409242bc93a939e63d5b126d140d03453b1c25292bf09f6b39' && \
    export url='https://downloads.plex.tv/plex-media-server' && \
    export version='1.0.0.2261-a17e99e' && \
    apt-get update -qq && \
    apt-get install -qqy --no-install-recommends ca-certificates curl \
                $(apt-get -s dist-upgrade|awk '/^Inst.*ecurity/ {print $2}') &&\
    mkdir -p /config/Library/Application\ Support && \
    ln -s /config /var/lib/plexmediaserver && \
    echo "downloading plexmediaserver_${version}_amd64.deb ..." && \
    curl -LOC- -s $url/$version/plexmediaserver_${version}_amd64.deb && \
    sha256sum plexmediaserver_${version}_amd64.deb | grep -q "$sha256sum" && \
    { dpkg -i plexmediaserver_${version}_amd64.deb || :; } && \
    { mkdir -p /config /data || :; } && \
    chown plex. -Rh /config && \
    chown plex. /data && \
    apt-get purge -qqy ca-certificates curl && \
    apt-get autoremove -qqy && apt-get clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* plexmediaserver_${version}_amd64.deb
COPY plex.sh /usr/bin/

VOLUME ["/config", "/data"]

EXPOSE 32400

ENTRYPOINT ["plex.sh"]