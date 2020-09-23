FROM ubuntu:18.04 as build

MAINTAINER Nathan Stitt <nathan@stitt.org>

RUN apt-get update && \
        apt-get install -y git curl && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists

ENV HUGO_VERSION="0.75.1"
ENV RELEASE_NAME=hugo_extended_${HUGO_VERSION}_Linux-64bit
ENV HUGO_URL=https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/${RELEASE_NAME}.tar.gz

RUN echo ${HUGO_URL}

RUN mkdir -p /usr/local/src \
    && cd /usr/local/src \
    && curl -L ${HUGO_URL} | tar -xz \
    && mv hugo /usr/local/bin/hugo \
    && rm /usr/local/src/*

WORKDIR /app

COPY . .

FROM nginx
COPY --from=build /usr/local/bin/hugo /usr/local/bin/hugo
EXPOSE 80
