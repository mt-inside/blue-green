FROM alpine:edge AS build

RUN apk update &&\
    apk add git build-base openssl-dev rust cargo &&\
    mkdir /app

WORKDIR /app
COPY . .

ENV RUSTFLAGS="-C target-feature=+crt-static"
RUN cargo build --target x86_64-alpine-linux-musl --release

FROM scratch
ARG COLOUR
COPY --from=build /app/target/x86_64-alpine-linux-musl/release/blue-green /
EXPOSE 8080
ENTRYPOINT ["/blue-green"]
ENV COLOUR=$COLOUR
