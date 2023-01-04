#!/usr/bin/env bash

# exit from script if error was raised.
set -xe

# error function is used within a bash function in order to send the error
# message directly to the stderr output and exit.
error() {
    echo "$1" > /dev/stderr
    exit 0
}

# return is used within bash function in order to return the value.
return() {
    echo "$1"
}

# set_default function gives the ability to move the setting of default
# env variable from docker file to the script thereby giving the ability to the
# user override it during container start.
set_default() {
    # docker initialized env variables with blank string and we can't just
    # use -z flag as usually.
    BLANK_STRING='""'

    VARIABLE="$1"
    DEFAULT="$2"

    if [[ -z "$VARIABLE" || "$VARIABLE" == "$BLANK_STRING" ]]; then

        if [ -z "$DEFAULT" ]; then
            error "You should specify default variable"
        else
            VARIABLE="$DEFAULT"
        fi
    fi

   return "$VARIABLE"
}

# Set default variables if needed.
RPCHOST=$(set_default "$RPCHOST" "localhost")
DEBUG=$(set_default "$DEBUG" "debug")
NETWORK=$(set_default "$NETWORK" "regtest")
CHAIN=$(set_default "$CHAIN" "bitcoin")
RPCPORT=$(set_default "$RPCPORT" "8332")
RPCUSER=$(set_default "$RPCUSER" "regtest")
RPCPASS=$(set_default "$RPCPASS" "regtest")
ZMQPUBRAWBLOCKPORT=$(set_default "$ZMQPUBRAWBLOCKPORT" "28332")
ZMQPUBRAWTXPORT=$(set_default "$ZMQPUBRAWTXPORT" "28333")
BACKEND="bitcoind"
HOSTNAME=$(hostname)

# CAUTION: DO NOT use the --noseedback for production/mainnet setups, ever!
# Also, setting --rpclisten to $HOSTNAME will cause it to listen on an IP
# address that is reachable on the internal network. If you do this outside of
# docker, this might be a security concern!

exec lnd \
    --noseedbackup \
    "--$CHAIN.active" \
    "--$CHAIN.$NETWORK" \
    "--$CHAIN.node"="$BACKEND" \
    "--$BACKEND.rpchost"="${RPCHOST}:${RPCPORT}" \
    "--$BACKEND.rpcuser"="$RPCUSER" \
    "--$BACKEND.rpcpass"="$RPCPASS" \
    "--$BACKEND.zmqpubrawblock"="${RPCHOST}:${ZMQPUBRAWBLOCKPORT}" \
    "--$BACKEND.zmqpubrawtx"="${RPCHOST}:${ZMQPUBRAWTXPORT}" \
    # "--rpclisten=$HOSTNAME:10009" \
    "--rpclisten=localhost:10009" \
    "--listen=localhost" \
    "--restlisten=0.0.0.0" \
    --debuglevel="$DEBUG" \
    "$@"
