FROM golang AS builder
RUN go get -u github.com/golang/dep/cmd/dep
WORKDIR /go/src/github.com/keycloak/keycloak-gatekeeper
COPY . .
RUN dep ensure
ENV CGO_ENABLED=0
RUN go install

FROM wisvch/debian:stretch-slim AS wisvch

FROM scratch
COPY --from=builder /go/bin/keycloak-gatekeeper /oidc-proxy
COPY --from=wisvch /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
USER 999
ENTRYPOINT ["/oidc-proxy"]
