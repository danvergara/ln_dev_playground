FROM golang:1.19.2-alpine as builder

# Force Go to use the cgo based DNS resolver. This is required to ensure DNS
# queries required to connect to linked containers succeed.
ENV GODEBUG netdns=cgo

# Install dependencies.
RUN apk add --no-cache --update alpine-sdk \
    git \
    make 

# Copy in the local repository to build from.
# COPY . /go/src/github.com/lightningnetwork/lnd
RUN git clone https://github.com/lightningnetwork/lnd.git /go/src/github.com/lightningnetwork/lnd

#  Install/build lnd.
RUN cd /go/src/github.com/lightningnetwork/lnd \
&&  make \
&& make clean \
&&  make install # tags="signrpc walletrpc chainrpc invoicesrpc peersrpc"

# Start a new, final image to reduce size.
FROM alpine

# Expose lnd ports (server, rpc).
EXPOSE 9735 10009

# Copy the binaries and entrypoint from the builder image.
COPY --from=builder /go/bin/lncli /bin/
COPY --from=builder /go/bin/lnd /bin/

# Add bash.
RUN apk add --no-cache \
    bash

# Copy the entrypoint script.
COPY "start-lnd.sh" .
RUN chmod +x start-lnd.sh
