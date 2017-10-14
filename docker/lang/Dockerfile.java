FROM frolvlad/alpine-oraclejdk8:slim

RUN mkdir -p /tmp/sandbox/input && \
    mkdir -p /tmp/sandbox/output && \
    mkdir -p /tmp/sandbox/validation && \
    mkdir -p /tmp/sandbox/submission && \
    touch /tmp/sandbox/output/test.out /tmp/sandbox/output/test.err /tmp/sandbox/output/returncode

WORKDIR /tmp/sandbox
