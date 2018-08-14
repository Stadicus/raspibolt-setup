# Trueno Full Node: Bitcoin Core
# ------------------------------
# based on https://github.com/ruimarinho/docker-bitcoin-core
# Copyright (c) 2015 Rui Marinho
#
# Example run:
# docker run -d --rm \
#       --name bitcoin-server \
#       --volume /mnt/hdd/bitcoin:/home/bitcoin/.bitcoin
#       --volume /opt/trueno/config/bitcoin.conf:/home/bitcoin/.bitcoin/bitcoin.conf
#       -p 18333:18333 \
#       -p 18332:18332 \
#       -p 29000:29000
#       truenolightning/bitcoin-core-armv71 \
#       -testnet=1
#
# mandatory volumes:
# /home/bitcoin/.bitcoin     data directory (blockchain 200GB+)
# /home/bitcoin/.bitcoin/bitcoin.conf   
#                            configuration file, can be mounted seperately
#
# TCP ports (mainnet / testnet)
# 8332 / 18332          JSON RPC port (only for local machine)
# 8333 / 18333          Peer-to-peer communication port
# 29000                 ZeroMQ interface

FROM debian:stable-slim

RUN useradd -r bitcoin \
  && apt-get update -y \
  && apt-get install -y curl gnupg \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && set -ex \
  && for key in \
    B42F6819007F00F88E364FD4036A9C25BF357DD4 \
  ; do \
    gpg --keyserver pgp.mit.edu --recv-keys "$key" || \
    gpg --keyserver keyserver.pgp.com --recv-keys "$key" || \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" || \
    gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" ; \
  done

ENV GOSU_VERSION=1.10

RUN curl -o /usr/local/bin/gosu -fSL https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture) \
  && curl -o /usr/local/bin/gosu.asc -fSL https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture).asc \
  && gpg --verify /usr/local/bin/gosu.asc \
  && rm /usr/local/bin/gosu.asc \
  && chmod +x /usr/local/bin/gosu

ENV BITCOIN_VERSION=0.16.2
ENV BITCOIN_DATA=/home/bitcoin/.bitcoin
ENV PATH=/opt/bitcoin-${BITCOIN_VERSION}/bin:$PATH

RUN curl -SL https://bitcoin.org/laanwj-releases.asc | gpg --import \
  && curl -SLO https://bitcoin.org/bin/bitcoin-core-${BITCOIN_VERSION}/SHA256SUMS.asc \
  && curl -SLO https://bitcoin.org/bin/bitcoin-core-${BITCOIN_VERSION}/bitcoin-${BITCOIN_VERSION}-arm-linux-gnueabihf.tar.gz \
  && gpg --verify SHA256SUMS.asc \
  && grep " bitcoin-${BITCOIN_VERSION}-arm-linux-gnueabihf.tar.gz\$" SHA256SUMS.asc | sha256sum -c - \
  && tar -xzf *.tar.gz -C /opt \
  && rm *.tar.gz *.asc

COPY docker-entrypoint.sh /entrypoint.sh

VOLUME ["/home/bitcoin/.bitcoin"]

EXPOSE 8332 8333 18332 18333 18443 18444 29000

ENTRYPOINT ["/entrypoint.sh"]

CMD ["bitcoind"]
