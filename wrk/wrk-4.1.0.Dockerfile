FROM debian:jessie
MAINTAINER flyceek@gmail.com

ARG WRK_VERSION=4.1.0
ARG WRK_FILE_NAME=${WRK_VERSION}.tar.gz
ARG WRK_FILE_SRC_DIR=wrk-${WRK_VERSION}
ARG WRK_FILE_URL=https://github.com/wg/wrk/archive/${WRK_FILE_NAME}

RUN apt-get update \
    && apt-get install build-essential libssl-dev wget -y \
    && mkdir -p /tmp/wrk/${WRK_FILE_SRC_DIR} \
    && cd /tmp/wrk \
    && wget -O ${WRK_FILE_NAME} ${WRK_FILE_URL} \
    && tar -xvf ${WRK_FILE_NAME} -C /tmp/wrk/${WRK_FILE_SRC_DIR} --strip-components=1 \
    && cd /tmp/wrk/${WRK_FILE_SRC_DIR} \
    && make \
    && cp ./wrk /usr/local/bin \
    && apt-get -f -y --auto-remove remove build-essential \
    && apt-get clean \
    && rm -rf /tmp/wrk

WORKDIR /data
ENTRYPOINT ["wrk"]