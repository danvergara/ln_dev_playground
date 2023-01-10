#!/bin/bash
set -e

LND_DATA=${LND_DATA:-/root/.lnd}
CHAIN=${CHAIN:-bitcoin}
CHAIN=${CHAIN,,}
CHAIN_TITLE=${CHAIN^}

BACKEND=${BACKEND:-bitcoind}
BACKEND=${BACKEND,,}
BACKEND_TITLE=${BACKEND^}

RPCHOST=${RPCHOST:-localhost}
RPCPORT=${RPCPORT:-8332}

ZMQPUBRAWBLOCKPORT=${ZMQPUBRAWBLOCKPORT:-28332}
ZMQPUBRAWTXPORT=${ZMQPUBRAWTXPORT:-28333}

# Generate the lnd.conf file
cat > "$LND_DATA/lnd.conf" <<EOF
[Application Options]
debuglevel=${DEBUGLEVEL:-info}
alias=${ALIAS:-alice}
rpclisten=localhost:10009
listen=localhost
restlisten=0.0.0.0
noseedbackup=${NOSEEDBACKUP:-false}

[${CHAIN_TITLE}]
${CHAIN}.active=${ACTIVE:-1}
${CHAIN}.mainnet=${MAINNET:-0}
${CHAIN}.testnet=${TESTNET:-0}
${CHAIN}.regtest=${REGTEST:-0}
${CHAIN}.node=$BACKEND

[${BACKEND_TITLE}]
${BACKEND}.rpchost=${RPCHOST}:${RPCPORT}
${BACKEND}.rpcuser=${RPCUSER:-regtest}
${BACKEND}.rpcpass=${RPCPASS:-regtest}
${BACKEND}.zmqpubrawblock=${RPCHOST}:${ZMQPUBRAWBLOCKPORT}
${BACKEND}.zmqpubrawtx=${RPCHOST}:${ZMQPUBRAWTXPORT}
EOF
