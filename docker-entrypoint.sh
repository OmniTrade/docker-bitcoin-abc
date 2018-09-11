#!/bin/bash
set -e

if [[ "$1" == "bitcoin-cli" || "$1" == "bitcoin-tx" || "$1" == "bitcoind" || "$1" == "test_bitcoin" ]]; then
	mkdir -p "$BITCOIN_DATA"

	if [[ ! -s "$BITCOIN_DATA/bitcoin.conf" ]]; then
		cat <<-EOF > "$BITCOIN_DATA/bitcoin.conf"
		server=1
		printtoconsole=1
		rpcallowip=::/0
		rpcpassword=${BITCOIN_RPC_PASSWORD:-password}
		rpcuser=${BITCOIN_RPC_USER:-bitcoin}
		walletnotify=/usr/bin/rabbitmqadmin -H ${RABBITMQ_HOST:-localhost} -P 443 --ssl --vhost ${RABBITMQ_USER:-user} -u ${RABBITMQ_USER:-user} -p ${RABBITMQ_PASSWORD:-password} publish routing_key=${RABBITMQ_ROUTING_KEY} payload='{"txid":"%s", "channel_key":"${RABBITMQ_CHANNEL_KEY}"}' 
		EOF
		chown bitcoin:bitcoin "$BITCOIN_DATA/bitcoin.conf"
	fi

	# ensure correct ownership and linking of data directory
	# we do not update group ownership here, in case users want to mount
	# a host directory and still retain access to it
	chown -R bitcoin "$BITCOIN_DATA"
	ln -sfn "$BITCOIN_DATA" /home/bitcoin/.bitcoin
	chown -h bitcoin:bitcoin /home/bitcoin/.bitcoin

	exec gosu bitcoin "$@"
fi

exec "$@"
