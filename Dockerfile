FROM rust:1.49.0 AS build

WORKDIR /app
COPY . .

#ENV RUSTFLAGS="-C target-feature=+crt-static -C link-arg=-s"
RUN cargo build --release

FROM gcr.io/distroless/cc
COPY --from=build /app/target/release/blue-green /

EXPOSE 8080
ENTRYPOINT ["/blue-green"]

ARG COLOUR
ENV COLOUR=$COLOUR
