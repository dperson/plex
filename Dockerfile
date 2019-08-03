FROM debian
MAINTAINER David Personette <dperson@gmail.com>

# Install Plex
RUN export DEBIAN_FRONTEND='noninteractive' && \
    export sha256sum='04002f06517940e4c8e64a711fac6d36b469545fcb3592b73a42' && \
    export url='https://downloads.plex.tv/plex-media-server-new' && \
    export version='1.16.3.1402-22929c8a2' && \
    apt-get update -qq && \
    apt-get install -qqy --no-install-recommends ca-certificates curl gnupg1 \
                procps \
                $(apt-get -s dist-upgrade|awk '/^Inst.*ecurity/ {print $2}') &&\
    mkdir -p /config/Library/Application\ Support && \
    ln -s /config /var/lib/plexmediaserver && \
    file="plexmediaserver_${version}_amd64.deb" && \
    echo "downloading $file ..." && \
    curl -LOSs $url/$version/debian/$file && \
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