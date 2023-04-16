#!/bin/sh

if [ -n "$SERVER_CERT" ]
then
    echo "Writing certificate to /certs/proxy.pem"
    umask 0022
    mkdir /certs
    echo $SERVER_CERT | grep -q ^PARM:
    if [ $? -eq 0 ]
    then
        SERVER_CERT=`echo $SERVER_CERT | sed 's/^PARM://'`
        aws ssm get-parameter --name $SERVER_CERT --with-decryption --query Parameter.Value --output text > /certs/proxy.pem
    else
        echo "$SERVER_CERT" > /certs/proxy.pem
    fi
fi

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- haproxy "$@"
fi

if [ "$1" = 'haproxy' ]; then
	shift # "haproxy"
	# if the user wants "haproxy", let's add a couple useful flags
	#   -W  -- "master-worker mode" (similar to the old "haproxy-systemd-wrapper"; allows for reload via "SIGUSR2")
	#   -db -- disables background mode
	set -- haproxy -W -db "$@"
fi

exec "$@"
