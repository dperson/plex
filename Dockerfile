FROM debian:jessie
MAINTAINER David Personette <dperson@dperson.com>

# Install Plex
RUN export DEBIAN_FRONTEND='noninteractive' && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys\
                5C808C2B65558117 && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys\
                E639BFCB72740199 && \
    echo "deb http://www.deb-multimedia.org jessie main non-free" >> \
                /etc/apt/sources.list && \
    echo "deb http://shell.ninthgate.se/packages/debian wheezy main" >> \
                /etc/apt/sources.list && \
    mkdir -p /config/Library/Application\ Support && \
    ln -s /config /var/lib/plexmediaserver && \
    apt-get update -qq && \
    apt-get install -qqy --no-install-recommends plexmediaserver && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/*
COPY plex.sh /usr/bin/

VOLUME ["/config", "/data"]

EXPOSE 32400

ENTRYPOINT ["plex.sh"]
