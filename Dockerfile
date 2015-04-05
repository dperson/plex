FROM debian:jessie
MAINTAINER David Personette <dperson@dperson.com>

# Install Plex
RUN export DEBIAN_FRONTEND='noninteractive' && \
    export url='https://downloads.plex.tv/plex-media-server' && \
    export version='0.9.11.16.958-80f1748' && \
    apt-get update -qq && \
    apt-get install -qqy --no-install-recommends ca-certificates curl \
                $(apt-get -s dist-upgrade|awk '/^Inst.*ecurity/ {print $2}') &&\
    mkdir -p /config/Library/Application\ Support && \
    ln -s /config /var/lib/plexmediaserver && \
    curl -LOC- -s $url/$version/plexmediaserver_${version}_amd64.deb && \
    dpkg -i plexmediaserver_${version}_amd64.deb || : && \
    apt-get purge -qqy ca-certificates curl && \
    apt-get autoremove -qqy && apt-get clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* plexmediaserver_${version}_amd64.deb
COPY plex.sh /usr/bin/

VOLUME ["/config", "/data"]

EXPOSE 32400

ENTRYPOINT ["plex.sh"]
