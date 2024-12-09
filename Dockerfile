FROM alpine:3.21

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

ARG arch=x86_64
ARG s6_overlay_version=3.2.0.2
ARG s6_overlay_arch_hash=59289456ab1761e277bd456a95e737c06b03ede99158beb24f12b165a904f478
ARG s6_overlay_noarch_hash=6dbcde158a3e78b9bb141d7bcb5ccb421e563523babbe2c64470e76f4fd02dae
ARG s6_overlay_symlinks_arch_hash=a50ca9cc9c773bfcee362a96a0c68aeef1088d6873ff2968edcb5c840b89a19b
ARG s6_overlay_symlinks_noarch_hash=da9552471ac9d324f07f22b546dfc36f0a76897d36a0f69952813feaec864a37

COPY container-files /

RUN apk add --no-cache wget ca-certificates && \
    apk --no-cache --update upgrade && \
    cd /tmp && \
    wget https://github.com/just-containers/s6-overlay/releases/download/v${s6_overlay_version}/s6-overlay-noarch.tar.xz && \
    echo "${s6_overlay_noarch_hash} *s6-overlay-noarch.tar.xz" | sha256sum -c - && \
    wget https://github.com/just-containers/s6-overlay/releases/download/v${s6_overlay_version}/s6-overlay-${arch}.tar.xz && \
    echo "${s6_overlay_arch_hash} *s6-overlay-${arch}.tar.xz" | sha256sum -c - && \
    wget https://github.com/just-containers/s6-overlay/releases/download/v${s6_overlay_version}/s6-overlay-symlinks-arch.tar.xz && \
    echo "${s6_overlay_symlinks_arch_hash} *s6-overlay-symlinks-arch.tar.xz" | sha256sum -c - && \
    wget https://github.com/just-containers/s6-overlay/releases/download/v${s6_overlay_version}/s6-overlay-symlinks-noarch.tar.xz && \
    echo "${s6_overlay_symlinks_noarch_hash} *s6-overlay-symlinks-noarch.tar.xz" | sha256sum -c - && \
    tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz && \
    tar -C / -Jxpf /tmp/s6-overlay-${arch}.tar.xz && \
    tar -C / -Jxpf /tmp/s6-overlay-symlinks-arch.tar.xz && \
    tar -C / -Jxpf /tmp/s6-overlay-symlinks-noarch.tar.xz && \
    rm s6-overlay-noarch.tar.xz && \
    rm s6-overlay-${arch}.tar.xz && \
    rm s6-overlay-symlinks-arch.tar.xz && \
    rm s6-overlay-symlinks-noarch.tar.xz

ENTRYPOINT ["/init"]
