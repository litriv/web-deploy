FROM golang:1.4.2

RUN mkdir -p /go/src/github.com/???/web
WORKDIR /go/src/github.com/???/web

# this will ideally be built by the ONBUILD below ;)
CMD ["go-wrapper", "run"]

COPY web /go/src/github.com/???/web

# RUN go-wrapper download
RUN go install

EXPOSE 8080
