#!/bin/bash
set -euxo pipefail

mkdir -p /tmp/.cache
export XDG_CACHE_HOME=/tmp/.cache

git clone --branch $SLURM_EXPORTER_TAG https://github.com/vpenso/prometheus-slurm-exporter.git /tmp/slurm-exporter
cd /tmp/slurm-exporter

go get -v

# Build the .deb and put it in /mnt, which is mounted from dist_*/ in the Makefile.
cd /mnt
fpm -s dir -t deb \
    -n prometheus-slurm-exporter \
    -v $(echo $SLURM_EXPORTER_TAG | sed 's/[^0-9.]*//g')~ocf1$DIST_TAG \
    --deb-generate-changes \
    --deb-dist $DIST_TAG \
    --description "Prometheus collector and exporter for metrics extracted from the Slurm resource scheduling system." \
    --url "https://github.com/ocf/prometheus-slurm-exporter-deb" \
    --maintainer "root@ocf.berkeley.edu" \
    --force \
    $GOBIN/=/usr/bin/ \
    /opt/prometheus-slurm-exporter.service=/lib/systemd/system/
