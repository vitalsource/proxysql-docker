FROM alpine:3.7

MAINTAINER Ryan Schwartz <ryan.schwartz@ingramcontent.com>

WORKDIR /tmp
RUN apk update && \
    apk add -t runtime-depends libgcc libstdc++ libcrypto1.0 libssl1.0 && \
    apk add -t build-depends build-base automake bzip2 patch git cmake openssl-dev libc6-compat libexecinfo-dev && \
    git clone https://github.com/sysown/proxysql.git && \
    cd proxysql && \
    git checkout v1.4.4 && \
    NOJEMALLOC=1 make && \
    cp src/proxysql /usr/bin/proxysql && \
    apk del build-depends && \
    cd && rm -rf /tmp/* /var/cache/apk/* 

COPY proxysql.cnf /proxysql/proxysql.cnf
ENTRYPOINT ["proxysql", "-f", "-c", "/proxysql/proxysql.cnf"]
