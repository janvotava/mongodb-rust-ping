FROM rust:1.71-alpine3.17 AS builder
RUN apk update && apk --no-cache add \
  musl-dev \
  make

WORKDIR /usr/src/mongodb-rust-ping
COPY . .

RUN --mount=type=cache,sharing=private,target=/usr/local/cargo/git \
  --mount=type=cache,sharing=private,target=/usr/local/cargo/registry \
  --mount=type=cache,sharing=private,target=/usr/src/mongodb-rust-ping/target \
  cargo install --path .

FROM alpine:3.17
RUN adduser -D pinger

COPY --from=builder /usr/local/cargo/bin/mongodb-rust-ping /usr/local/bin/mongodb-rust-ping

USER pinger

CMD ["mongodb-rust-ping"]
