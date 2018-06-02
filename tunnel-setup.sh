#!/bin/bash

set -e

user=${2:-root}
server=${3:-example.com}
remotePort=${4:-4545}
localPort=${1:-3333}

AUTOSSH_SERVER_ALIVE_INTERVAL=30
AUTOSSH_SERVER_ALIVE_COUNT=2
export AUTOSSH_POLL=30
export AUTOSSH_GATETIME=0
export AUTOSSH_LOGFILE="/tmp/autossh.log"

touch $AUTOSSH_LOGFILE
rm $AUTOSSH_LOGFILE || true

autossh -f -M 0 \
	-o "ExitOnForwardFailure yes" \
	-o "ServerAliveInterval $AUTOSSH_SERVER_ALIVE_INTERVAL" \
	-o "ServerAliveCountMax $AUTOSSH_SERVER_ALIVE_COUNT" \
	-NR $remotePort:localhost:$localPort $user@$server

echo Created tunnel from localhost:$localPort to $user@$server:$remotePort
