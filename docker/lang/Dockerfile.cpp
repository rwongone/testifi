FROM frolvlad/alpine-gcc:latest

RUN mkdir -p /tmp/sandbox/input && \
    mkdir -p /tmp/sandbox/output && \
    mkdir -p /tmp/sandbox/validation && \
    mkdir -p /tmp/sandbox/submission && \
    apk add --update g++

WORKDIR /tmp/sandbox
