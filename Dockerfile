FROM alpine

MAINTAINER Ryan Schwartz <ryan.schwartz@ingramcontent.com>

WORKDIR /tmp
COPY musl-compat.patch /tmp/musl-compat.patch
RUN apk update && \
    apk add -t runtime-depends libgcc libstdc++ && \
    apk add -t build-depends build-base automake bzip2 patch git cmake openssl-dev libc6-compat && \
    apk add --no-cache -t edge-build-depends --repository http://dl-3.alpinelinux.org/alpine/edge/main libexecinfo-dev && \
    git clone https://github.com/sysown/proxysql.git && \
    cd proxysql && \
    git checkout v1.2.1 && \
    patch -p 0 < /tmp/musl-compat.patch  && \
    make && \
    cp src/proxysql /usr/bin/proxysql && \
    apk del build-depends edge-build-depends && \
    cd && rm -rf /tmp/* /var/cache/apk/* 

COPY proxysql.cnf /proxysql/proxysql.cnf
COPY proxysql.db /var/lib/proxysql/proxysql.db
ENTRYPOINT ["proxysql", "-f", "-c", "/proxysql/proxysql.cnf", "--reload"]
