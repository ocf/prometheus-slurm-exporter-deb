FROM docker.ocf.berkeley.edu/theocf/debian:stretch

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
            git \
            ruby \
            ruby-dev \
            rubygems \
            ruby-bundler \
            build-essential \
            golang-1.11 \
            golang-github-prometheus-client-golang-dev

COPY Gemfile /opt
COPY Gemfile.lock /opt
RUN bundle install --gemfile=/opt/Gemfile

ENV PATH="${PATH}:/usr/lib/go-1.11/bin"
# go needs places to put its build files, and the built binaries.
RUN mkdir -m 0777 /opt/go
ENV GOPATH=/opt/go
RUN mkdir -m 0777 /opt/go/bin
ENV GOBIN=/opt/go/bin

COPY package.sh /opt
COPY prometheus-slurm-exporter.service /opt

CMD ["/opt/package.sh"]
