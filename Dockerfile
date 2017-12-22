FROM alpine:3.7 as builder
MAINTAINER Ryan Schwartz <ryan.schwartz@ingramcontent.com>
WORKDIR /tmp
RUN apk add --no-cache -t build-depends build-base automake bzip2 patch git cmake openssl-dev libc6-compat libexecinfo-dev
RUN git clone https://github.com/sysown/proxysql.git
RUN cd proxysql && \
    git checkout v1.4.4 && \
    make clean && \
    make build_deps && \
    NOJEMALLOC=1 make

FROM alpine:3.7
MAINTAINER Ryan Schwartz <ryan.schwartz@ingramcontent.com>
RUN apk add --no-cache -t runtime-depends libgcc libstdc++ libcrypto1.0 libssl1.0
COPY --from=builder /tmp/proxysql/src/proxysql /usr/bin/proxysql
COPY proxysql.cnf /proxysql/proxysql.cnf
ENTRYPOINT ["proxysql", "-f", "-c", "/proxysql/proxysql.cnf"]