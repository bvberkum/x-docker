ARG X_DCKR_TAG=edge
FROM alpine:$X_DCKR_TAG
MAINTAINER B. van Berkum <dev@dotmpe.com>

RUN apk update && \
    apk add --no-cache \
      bash docker && \
    rm -rf /var/cache/apk/*

CMD ["docker","-h"]
# Id: x-docker/0.0.2-dev ./alpine-docker/latest/Dockerfile
