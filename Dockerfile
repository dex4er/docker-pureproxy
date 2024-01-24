ARG ALPINE_TAG=latest
ARG PERL_VERSION=~5
ARG PUREPROXY_RELEASE=master
ARG VERSION=${PUREPROXY_RELEASE}
ARG REVISION
ARG BUILDDATE

FROM alpine:${ALPINE_TAG}

ARG PERL_VERSION
ARG PUREPROXY_RELEASE
ARG VERSION
ARG REVISION
ARG BUILDDATE

WORKDIR /usr/local/bin

RUN apk --no-cache add perl=${PERL_VERSION} perl-io-socket-ssl && rm -f /var/cache/apk/*

ADD --chmod=755 https://raw.githubusercontent.com/dex4er/PureProxy/${PUREPROXY_RELEASE}/fatpack/pureproxy .

ENTRYPOINT ["pureproxy"]

EXPOSE 5000

LABEL \
  maintainer="Piotr Roszatycki <piotr.roszatycki@gmail.com>" \
  org.opencontainers.image.created=${BUILDDATE} \
  org.opencontainers.image.description="Pure Perl HTTP proxy server" \
  org.opencontainers.image.licenses="MIT" \
  org.opencontainers.image.revision=${REVISION} \
  org.opencontainers.image.source=https://github.com/dex4er/pureproxy \
  org.opencontainers.image.title=pureproxy \
  org.opencontainers.image.url=https://github.com/dex4er/pureproxy \
  org.opencontainers.image.vendor=dex4er \
  org.opencontainers.image.version=${VERSION}
