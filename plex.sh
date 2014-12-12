#!/usr/bin/env bash
#===============================================================================
#          FILE: plex.sh
#
#         USAGE: ./plex.sh
#
#   DESCRIPTION: Entrypoint for plex docker container
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: David Personette (dperson@gmail.com),
#  ORGANIZATION:
#       CREATED: 09/28/2014 12:11
#      REVISION: 1.0
#===============================================================================

set -o nounset                              # Treat unset variables as an error

### timezone: Set the timezone for the container
# Arguments:
#   timezone) for example EST5EDT
# Return: the correct zoneinfo file will be symlinked into place
timezone() {
    local timezone="${1:-EST5EDT}"

    [[ -e /usr/share/zoneinfo/$timezone ]] || {
        echo "ERROR: invalid timezone specified" >&2
        return
    }

    ln -sf /usr/share/zoneinfo/$timezone /etc/localtime
}

### usage: Help
# Arguments:
#   none)
# Return: Help text
usage() {
    local RC=${1:-0}

    echo "Usage: ${0##*/} [-opt] [command]
Options (fields in '[]' are optional, '<>' are required):
    -h          This help
    -t \"\"       Configure timezone
                possible arg: \"[timezone]\" - zoneinfo timezone for container

The 'command' (if provided and valid) will be run instead of plex
" >&2
    exit $RC
}

while getopts ":ht:" opt; do
    case "$opt" in
        h) usage ;;
        t) timezone "$OPTARG" ;;
        "?") echo "Unknown option: -$OPTARG"; usage 1 ;;
        ":") echo "No argument value for option: -$OPTARG"; usage 2 ;;
    esac
done
shift $(( OPTIND - 1 ))

[[ "${TIMEZONE:-""}" ]] && timezone "$TIMEZONE"


if [[ $# -ge 1 && -x $(which $1 2>&-) ]]; then
    exec "$@"
elif [[ $# -ge 1 ]]; then
    echo "ERROR: command not found: $1"
    exit 13
else
    APPDIR="/config/Library/Application Support/Plex Media Server"
    rm -f "$APPDIR"/*.pid
    rm -rf /var/run/*
    mkdir -p /var/run/dbus
    chown messagebus. /var/run/dbus
    dbus-uuidgen --ensure
    dbus-daemon --system --fork
    sleep 1
    avahi-daemon -D
    sleep 1
    chown plex. -Rh /config
    chown plex. /data
    su -l plex -c "/usr/sbin/start_pms &" >/dev/null 2>&1
    sleep 5
    eval tail -f $(find "$APPDIR/Logs" -iname \*.log | sed 's/^/"/; s/$/"/')
fi
