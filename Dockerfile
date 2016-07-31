FROM abaez/lua
MAINTAINER Jay Thomas <jay@gfax.ch>

ENV LUAROCKS_VERSION 2.3.0
ENV LUAROCKS_INSTALL luarocks-$LUAROCKS_VERSION
ENV TMP_LOC /tmp/luarocks

## LUACOV PLACEHOLDER...
## Build additional system packages
#RUN apk update && \
    #apk upgrade && \
    #apk add python && \
    #rm -rf /var/cache/apk/*

## Build pip and cpp-coveralls
#RUN curl -O https://bootstrap.pypa.io/get-pip.py
#RUN python get-pip.py
#RUN pip install cpp-coveralls

# Build luarocks
RUN curl -O http://keplerproject.github.io/luarocks/releases/$LUAROCKS_INSTALL.tar.gz

RUN tar xvzf $LUAROCKS_INSTALL.tar.gz && \
    mv $LUAROCKS_INSTALL $TMP_LOC && \
    rm $LUAROCKS_INSTALL.tar.gz


WORKDIR $TMP_LOC

RUN ./configure \
  --with-lua=$WITH_LUA \
  --with-lua-include=$LUA_INCLUDE \
  --with-lua-lib=$LUA_LIB

RUN make build

RUN make install

WORKDIR /

RUN rm -rf $TMP_LOC

## Luarocks
RUN luarocks install luacheck
RUN luarocks install luacov-coveralls

## App setup
RUN mkdir /usr/app
WORKDIR /usr/app
COPY . /usr/app

## Run tests
CMD ["luacheck", "."]

# Future use...
#CMD ["coveralls", "--exclude lib", "--dump", "c.report.json"]
#CMD ["luacov-coveralls", "-j", "c.report.json"]
