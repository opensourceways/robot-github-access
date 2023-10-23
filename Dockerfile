FROM openeuler/openeuler:23.03 as BUILDER
RUN dnf update -y && \
    dnf install -y golang && \
    go env -w GOPROXY=https://goproxy.cn,direct

MAINTAINER zengchen1024<chenzeng765@gmail.com>

# build binary
WORKDIR /go/src/github.com/opensourceways/robot-github-access
COPY . .
RUN GO111MODULE=on CGO_ENABLED=0 go build -a -o robot-github-access .

# copy binary config and utils
FROM openeuler/openeuler:22.03
RUN dnf -y update && \
    dnf in -y shadow && \
    groupadd -g 1000 access && \
    useradd -u 1000 -g access -s /bin/bash -m access

USER access

COPY  --chown=access  --from=BUILDER /go/src/github.com/opensourceways/robot-github-access/robot-github-access /opt/app/robot-github-access

ENTRYPOINT ["/opt/app/robot-github-access"]
