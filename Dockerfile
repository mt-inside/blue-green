FROM rust:1.54 AS build
RUN rustup target add x86_64-unknown-linux-musl
ENV CARGO_BUILD_TARGET="x86_64-unknown-linux-musl"
ENV RUSTFLAGS="-C target-feature=+crt-static -C link-arg=-s"

WORKDIR /app
COPY Cargo.* ./
COPY src ./src/
RUN cargo build --release

FROM scratch
COPY --from=build /app/target/x86_64-unknown-linux-musl/release/blue-green /

EXPOSE 8080
ENTRYPOINT ["/blue-green"]

ARG COLOUR
ENV COLOUR=$COLOUR
