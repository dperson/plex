FROM debian:stretch
MAINTAINER David Personette <dperson@gmail.com>

# Install Plex
RUN export DEBIAN_FRONTEND='noninteractive' && \
    export sha256sum='daf9c008d495d5771c9eb3c6ec9c59fb4be4335d37558ec0448b' && \
    export url='https://downloads.plex.tv/plex-media-server' && \
    export version='1.13.9.5456-ecd600442' && \
    apt-get update -qq && \
    apt-get install -qqy --no-install-recommends ca-certificates curl gnupg1 \
                procps \
                $(apt-get -s dist-upgrade|awk '/^Inst.*ecurity/ {print $2}') &&\
    mkdir -p /config/Library/Application\ Support && \
    ln -s /config /var/lib/plexmediaserver && \
    file="plexmediaserver_${version}_amd64.deb" && \
    echo "downloading $file ..." && \
    curl -LOSs $url/$version/$file && \
    sha256sum $file | grep -q "$sha256sum" || \
    { echo "expected $sha256sum, got $(sha256sum $file)"; exit 13; } && \
    { dpkg -i $file || :; } && \
    { mkdir -p /config /data || :; } && \
    chown plex. -Rh /config && \
    chown plex. /data && \
    apt-get purge -qqy ca-certificates curl gnupg1 && \
    apt-get autoremove -qqy && apt-get clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* $file
COPY plex.sh /usr/bin/

VOLUME ["/config", "/data"]

EXPOSE 32400

ENTRYPOINT ["plex.sh"]