FROM debian:stretch-slim
MAINTAINER Stefan Großmann <39296252+stgrossmann@users.noreply.github.com>

RUN set -ex \
  && apt-get update \
  && apt-get install -qq --no-install-recommends dirmngr ca-certificates wget \
  && rm -rf /var/lib/apt/lists/*

ARG LTC_VERSION=0.16.3
ARG LTC_URL=https://download.litecoin.org/litecoin-0.16.3/linux/litecoin-0.16.3-x86_64-linux-gnu.tar.gz
ARG LTC_SHA256=686d99d1746528648c2c54a1363d046436fd172beadaceea80bdc93043805994

RUN set -ex \
  && cd /tmp \
  && wget -qO litecoin-${LTC_VERSION}.tar.gz ${LTC_URL} \
  && echo ${LTC_SHA256} litecoin-${LTC_VERSION}.tar.gz | sha256sum -c - \
  && tar -xzvf litecoin-${LTC_VERSION}.tar.gz -C /usr/local --strip-components=1 --exclude=*-qt \
  && rm -rf /tmp/*

RUN groupadd -r -g 555 litecoin && useradd -r -m -u 555 -g litecoin litecoin
ENV DATADIR /data

RUN mkdir "$DATADIR" \
  && chown -R 555:555 "$DATADIR" \
  && ln -sfn "$DATADIR" /home/litecoin/.litecoin \
  && chown -h 555:555 /home/litecoin/.litecoin

VOLUME /data

EXPOSE 9333 19335

USER 555:555
ENTRYPOINT ["litecoind"]
