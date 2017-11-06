FROM ubuntu:16.04

# buildtools has to be ahead of depot_tools.
ENV PATH=$PATH:/buildtools:/depot_tools

# install dependencies
COPY install-deps.sh /install-deps.sh
RUN /install-deps.sh

WORKDIR /workdir

COPY ./src/* /src/
