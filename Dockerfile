# TODO: make this build x86_64 and aarch64

FROM rust:1.65.0 AS build
RUN rustup target add aarch64-unknown-linux-musl
#RUN rustup toolchain add nightly
#RUN rustup component add rust-src --toolchain nightly
#RUN apt update && apt install -y musl musl-dev
RUN cargo search serde # pre-warm crates cache

WORKDIR /app
COPY Cargo.* ./
COPY src ./src/
ENV CARGO_BUILD_TARGET="aarch64-unknown-linux-musl"
ENV RUSTFLAGS="-C target-feature=+crt-static -C link-arg=-s"
# Following: https://github.com/johnthagen/min-sized-rust
# TODO: doesn't work, won't link
#RUN cargo +nightly build -Z build-std=std,panic_abort --target aarch64-unknown-linux-musl --release
RUN cargo build --release

FROM scratch
COPY --from=build /app/target/aarch64-unknown-linux-musl/release/blue-green /

EXPOSE 8080
ENTRYPOINT ["/blue-green"]

ARG COLOUR
ENV COLOUR=$COLOUR
