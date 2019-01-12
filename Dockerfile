FROM docker.ocf.berkeley.edu/theocf/debian:stretch

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
            git \
            ruby \
            ruby-dev \
            rubygems \
            build-essential \
            golang-1.10 \
            golang-github-prometheus-client-golang-dev

RUN gem install --no-ri --no-rdoc fpm -v 1.10.2

ENV PATH="${PATH}:/usr/lib/go-1.10/bin"
# go needs places to put its build files, and the built binaries.
RUN mkdir -m 0777 /opt/go
ENV GOPATH=/opt/go
RUN mkdir -m 0777 /opt/go/bin
ENV GOBIN=/opt/go/bin

COPY package.sh /opt
COPY prometheus-slurm-exporter.service /opt

CMD ["/opt/package.sh"]
