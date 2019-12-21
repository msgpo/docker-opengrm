ARG BUILD_FROM
FROM $BUILD_FROM

ARG MAKE_THREADS=8

COPY etc/qemu-arm-static /usr/bin/
COPY etc/qemu-aarch64-static /usr/bin/

RUN apt-get update
RUN apt-get install -y --no-install-recommends \
        build-essential

ARG FRIENDLY_ARCH

COPY dist/openfst-1.6.9-${FRIENDLY_ARCH}.tar.gz /
COPY download/opengrm-ngram-1.3.4.tar.gz /

RUN mkdir -p /build && \
    tar -C /build -xvf /openfst-1.6.9-${FRIENDLY_ARCH}.tar.gz

ENV CXXFLAGS="-I/build/include"
ENV LDFLAGS="-L/build/lib"

RUN cd / && tar -xf opengrm-ngram-1.3.4.tar.gz && cd opengrm-ngram-1.3.4/ && \
    ./configure \
        --prefix=/build \
        --enable-static && \
    make -j $MAKE_THREADS && \
    make install