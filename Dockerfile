FROM golang:1.11.0 as builder

# Set our workdir to our current service in the gopath
WORKDIR /go/src/github.com/caquillo07/grpc-demo-user-cli

# copy the entire code into our workdir
COPY . .

RUN go get -u github.com/golang/dep/cmd/dep
RUN dep ensure -v
RUN CGO_ENABLED=0 GOOS=linux go build -o user-cli -a -installsuffix cgo .

FROM alpine:latest

RUN apk --no-cache add ca-certificates

RUN mkdir /app
WORKDIR /app

COPY --from=builder /go/src/github.com/caquillo07/grpc-demo-user-cli/user-cli .

ENTRYPOINT ["./user-cli"]
CMD ["./user-cli"]