FROM ubuntu:trusty
MAINTAINER David Personette <dperson@dperson.com>

# Install Plex
COPY plex.sh /usr/bin/
RUN TERM=dumb apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys\
                E639BFCB72740199 && \
    echo "deb http://shell.ninthgate.se/packages/debian squeeze main" >> \
                /etc/apt/sources.list && \
    TERM=dumb apt-get update -qq && \
    TERM=dumb apt-get install -qqy --no-install-recommends plexmediaserver && \
    TERM=dumb apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/*

VOLUME ["/config", "/data"]

EXPOSE 32400

ENTRYPOINT ["plex.sh"]
