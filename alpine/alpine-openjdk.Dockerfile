FROM alpine:3.5

ARG JAVA_VERSION=8u121
ARG JAVA_ALPINE_VERSION=8.121.13-r0

ENV LANG C.UTF-8
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
ENV PATH $PATH:${JAVA_HOME}/jre/bin:${JAVA_HOME}/bin

RUN { \
		echo '#!/bin/sh'; \
		echo 'set -e'; \
		echo; \
		echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
	} > /usr/local/bin/docker-java-home \
	&& chmod +x /usr/local/bin/docker-java-home

RUN set -x \
	&& apk add --no-cache openjdk8="$JAVA_ALPINE_VERSION" \
	&& [ "$JAVA_HOME" = "$(docker-java-home)" ]