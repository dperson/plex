[![logo](https://raw.githubusercontent.com/dperson/plex/master/logo.png)](https://plex.tv/)

# Plex

Plex docker container

# What is Plex?

The free Plex Media Server simplifies your life by organizing all of your
personal media, making it beautiful and streaming it to all of your devices.

# How to use this image

This Plex container will initialize the config directory and exit on first run.
When it has completed, edit
`your_config_location/Library/Application Support/Plex Media Server/Preferences.xml`
to add your network to the allowed list (IE
`allowedNetworks="192.168.1.0/255.255.255.0"` with your network range).

Restart the docker instance once more and proceed to setup plex at
`http://*ipaddress*:32400/web`.

For more detailed instructions please see the
[plex site](https://support.plex.tv/hc/en-us/articles/200264746-Quick-Start-Step-by-Step).

## Hosting a Plex instance

    sudo docker run --name plex -p 32400:32400 -d dperson/plex

OR use local storage:

    sudo docker run --name plex -p 32400:32400 \
                -v /path/to/directory:/config \
                -v /path/to/media:/data \
                -d dperson/plex

## Configuration

    sudo docker run -it --rm dperson/plex -h

    Usage: plex.sh [-opt] [command]
    Options (fields in '[]' are optional, '<>' are required):
        -h          This help
        -t ""       Configure timezone
                    possible arg: "[timezone]" - zoneinfo timezone for container

    The 'command' (if provided and valid) will be run instead of plex

ENVIROMENT VARIABLES (only available with `docker run`)

 * `TZ` - As above, configure the zoneinfo timezone, IE `EST5EDT`
 * `USERID` - Set the UID for the app user
 * `GROUPID` - Set the GID for the app user

## Examples

Any of the commands can be run at creation with `docker run` or later with
`docker exec plex.sh` (as of version 1.3 of docker).

### Setting the Timezone

    sudo docker run --name plex -p 32400:32400 -d dperson/plex -t EST5EDT

OR using `environment variables`

    sudo docker run --name plex -e TZ=EST5EDT -p 32400:32400 -d dperson/plex

Will get you the same settings as

    sudo docker run --name plex -p 32400:32400 -d dperson/plex
    sudo docker exec plex plex.sh -t EST5EDT ls -AlF /etc/localtime
    sudo docker restart plex

# User Feedback

## Issues

If you have any problems with or questions about this image, please contact me
through a [GitHub issue](https://github.com/dperson/plex/issues).
