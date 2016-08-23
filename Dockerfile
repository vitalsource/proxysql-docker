FROM alpine

MAINTAINER Ryan Schwartz <ryan.schwartz@ingramcontent.com>

WORKDIR /tmp
COPY musl-ProxySQL_GloVars.cpp.patch /tmp/musl-ProxySQL_GloVars.cpp.patch
RUN apk add --no-cache build-base automake bzip2 patch git cmake openssl-dev libc6-compat && \
    apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/main libexecinfo-dev && \
    git clone https://github.com/sysown/proxysql.git && \
    cd proxysql && \
    git checkout v1.2.1 && \
    patch lib/ProxySQL_GloVars.cpp < /tmp/musl-ProxySQL_GloVars.cpp.patch  && \
    make -k ; \
    echo "==========================" ; \
    echo "Running make a second time" ; \
    echo "==========================" ; \
    make && \
    cp src/proxysql /usr/bin/proxysql

COPY proxysql.cnf /proxysql/proxysql.cnf
COPY proxysql.db /var/lib/proxysql/proxysql.db
ENTRYPOINT ["proxysql", "-f", "-c", "/proxysql/proxysql.cnf", "--reload"]
