FROM alpine:3.20 AS build

WORKDIR /build

ENV VERSION=1.5

RUN apk add --no-cache alpine-sdk git cmake openssl-dev zlib-dev libssl3 curl subversion libcurl curl-dev

RUN git clone --branch ${VERSION} --depth=1 https://github.com/supertuxkart/stk-code.git

RUN svn checkout https://svn.code.sf.net/p/supertuxkart/code/stk-assets stk-assets --quiet

RUN mkdir -p stk-code/cmake_build && \
    cd stk-code/cmake_build && \
    cmake .. -DSERVER_ONLY=ON && \
    make -j$(nproc) && \
    make install

FROM alpine:3.20

RUN apk add --no-cache curl libstdc++ bash

COPY --from=build /usr/local/bin/supertuxkart /usr/local/bin
COPY --from=build /usr/local/share/supertuxkart /usr/local/share/supertuxkart

RUN mkdir -p /app/config

WORKDIR /app

COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

EXPOSE 2757 2759

ENTRYPOINT ["/app/entrypoint.sh"]
