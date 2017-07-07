FROM frolvlad/alpine-oraclejdk8:slim

RUN mkdir -p /tmp/sandbox/input && \
    mkdir -p /tmp/sandbox/output && \
    mkdir -p /tmp/sandbox/validation && \
    mkdir -p /tmp/sandbox/submission

WORKDIR /tmp/sandbox
