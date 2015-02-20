FROM ubuntu:trusty
MAINTAINER David Personette <dperson@dperson.com>

ENV DEBIAN_FRONTEND noninteractive

# Install Plex
RUN export DEBIAN_FRONTEND='noninteractive' && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys\
                E639BFCB72740199 && \
    echo "deb http://shell.ninthgate.se/packages/debian squeeze main" >> \
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
