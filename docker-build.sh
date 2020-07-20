#!/usr/bin/env bash
set -e

if [[ $UID != 0 ]]; then
    echo "You have to run this as root." 1>&2
    exit 1
fi

if ! type docker >/dev/null 2>&1; then
    echo "You have to install docker." 1>&2
    exit 1
fi

SCRIPT_DIR=$(cd $(dirname $0); pwd)
cd $SCRIPT_DIR
docker build -it alterlinux-build:latest .
docker run -e _DOCKER=true -it --privileged -v $SCRIPT_DIR/out:/alterlinux/out -v /usr/lib/modules:/usr/lib/modules:ro alterlinux-build >/dev/null 2>&1
