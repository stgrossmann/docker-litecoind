FROM debian:stretch-slim
MAINTAINER Stefan Großmann <39296252+stgrossmann@users.noreply.github.com>

RUN set -ex \
  && apt-get update \
  && apt-get install -qq --no-install-recommends dirmngr ca-certificates wget \
  && rm -rf /var/lib/apt/lists/*

ARG LTC_VERSION=0.17.1
ARG LTC_URL=https://download.litecoin.org/litecoin-0.17.1/linux/litecoin-0.17.1-x86_64-linux-gnu.tar.gz
ARG LTC_SHA256=9cab11ba75ea4fb64474d4fea5c5b6851f9a25fe9b1d4f7fc9c12b9f190fed07

RUN set -ex \
  && cd /tmp \
  && wget -qO litecoin-${LTC_VERSION}.tar.gz ${LTC_URL} \
  && echo ${LTC_SHA256} litecoin-${LTC_VERSION}.tar.gz | sha256sum -c - \
  && tar -xzvf litecoin-${LTC_VERSION}.tar.gz -C /usr/local --strip-components=1 --exclude=*-qt \
  && rm -rf /tmp/*

RUN groupadd -g 1000 litecoin && useradd -m -u 1000 -g litecoin -s /bin/sh litecoin

USER litecoin

RUN mkdir -p /home/litecoin/.litecoin

VOLUME /home/litecoin/.litecoin

EXPOSE 9333 19335

ENTRYPOINT ["litecoind"]
