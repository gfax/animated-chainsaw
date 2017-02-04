FROM abaez/luarocks:lua5.1
MAINTAINER Jay Thomas <jay@gfax.ch>

## Build additional system packages
RUN apk update && \
    apk upgrade && \
    # luacov dependency
    apk add python && \
    rm -rf /var/cache/apk/*

## Build pip and cpp-coveralls
RUN curl -O https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py
RUN pip install cpp-coveralls

## Luarocks
RUN luarocks install busted 2.0.rc12-1
RUN luarocks install luacheck
RUN luarocks install luacov
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
