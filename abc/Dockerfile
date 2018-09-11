FROM debian:stretch-slim

ENV BITCOIN_VERSION 0.18.1
ENV BITCOIN_URL https://download.bitcoinabc.org/0.18.1/linux/bitcoin-abc-0.18.1-x86_64-linux-gnu.tar.gz
# get bitcoin-abc sha here: https://download.bitcoinabc.org/0.18.1/linux/bitcoin-abc-0.18-linux-res.yml 
ENV BITCOIN_SHA256 f955a929d4412b479115abecdb54e8b57791bb59c8578ccfaefb13eb625bc4cb
# Vars related to data directory creation 
ENV BITCOIN_DATA /data

COPY ../docker-entrypoint.sh /entrypoint.sh
COPY ../rabbitmqadmin /usr/bin/rabbitmqadmin
COPY ../google-logger /usr/bin/google-logger

RUN groupadd -r bitcoin && useradd -r -m -g bitcoin bitcoin \
    && set -ex \
	&& apt-get update \
    && apt-get install -qq --no-install-recommends ca-certificates dirmngr gosu gpg wget python-setuptools python-pip procps htop\
    && rm -rf /var/lib/apt/lists/* \    
# run pip	
	&& pip install --upgrade google-cloud-logging \
    && pip install --upgrade grpcio==1.7.3 \
# install bitcoin binaries
    && set -ex \
	&& cd /tmp \
	&& wget -qO bitcoin.tar.gz "$BITCOIN_URL" \
	&& echo "$BITCOIN_SHA256 bitcoin.tar.gz" | sha256sum -c - \
	&& tar -xzvf bitcoin.tar.gz -C /usr/local --strip-components=1 --exclude=*-qt \
	&& rm -rf /tmp/* \
# create data directory	
    && mkdir "$BITCOIN_DATA" \
	&& chown -R bitcoin:bitcoin "$BITCOIN_DATA" \
	&& ln -sfn "$BITCOIN_DATA" /home/bitcoin/.bitcoin \
	&& chown -h bitcoin:bitcoin /home/bitcoin/.bitcoin \
# set permissions to files	
    && chmod +x /usr/bin/rabbitmqadmin \
    && chmod +x /usr/bin/google-logger

VOLUME /data

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 8332 8333 18332 18333
CMD ["bitcoind"]
