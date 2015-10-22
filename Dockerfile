FROM debian:jessie
MAINTAINER David Personette <dperson@dperson.com>

# Install Plex
RUN export DEBIAN_FRONTEND='noninteractive' && \
    export sha256sum='267c8b1d876743971e3a9978405818ff5ca731c4c870b0650761' && \
    export url='https://downloads.plex.tv/plex-media-server' && \
    export version='0.9.12.13.1464-4ccd2ca' && \
    apt-get update -qq && \
    apt-get install -qqy --no-install-recommends ca-certificates curl \
                $(apt-get -s dist-upgrade|awk '/^Inst.*ecurity/ {print $2}') &&\
    mkdir -p /config/Library/Application\ Support && \
    ln -s /config /var/lib/plexmediaserver && \
    curl -LOC- -s $url/$version/plexmediaserver_${version}_amd64.deb && \
    sha256sum plexmediaserver_${version}_amd64.deb | grep -q "$sha256sum" && \
    dpkg -i plexmediaserver_${version}_amd64.deb || : && \
    mkdir -p /config /data || : && \
    chown plex. -Rh /config && \
    chown plex. /data && \
    apt-get purge -qqy ca-certificates curl && \
    apt-get autoremove -qqy && apt-get clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* plexmediaserver_${version}_amd64.deb
COPY plex.sh /usr/bin/

VOLUME ["/run", "/tmp", "/var/cache", "/var/lib", "/var/log", "/var/tmp", \
            "/config", "/data"]

EXPOSE 32400

ENTRYPOINT ["plex.sh"]
