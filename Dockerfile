FROM alpine:latest

ARG BUILD_DATE
ARG VCS_REF

LABEL maintainer="antman666@qq.com" \
    org.opencontainers.image.title="s6-alpine" \
    org.opencontainers.image.description="Alpine Base with S6 Overlay" \
    org.opencontainers.image.authors="antman666@qq.com" \
    org.opencontainers.image.vendor="Alpine" \
    org.opencontainers.image.documentation="https://docs.alpinelinux.org" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://alpinelinux.org" \
    org.opencontainers.image.revision=$VCS_REF \
    org.opencontainers.image.created=$BUILD_DATE

COPY container-files /
COPY build.sh /root

RUN apk --no-cache --update upgrade
RUN apk add --no-cache wget ca-certificates bash curl
RUN bash /root/build.sh
RUN rm /root/build.sh
RUN adduser -D aria2

ENTRYPOINT ["/init"]
