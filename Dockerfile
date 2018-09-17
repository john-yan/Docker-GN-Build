FROM ubuntu:16.04

RUN apt update && apt install -y git clang g++ vim

WORKDIR /workdir

COPY ./src/* /src/

ENV PATH=$PATH:/buildtools
