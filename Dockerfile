FROM ubuntu:16.04

# buildtools has to be ahead of depot_tools.
ENV PATH=$PATH:/buildtools:/depot_tools
ENV VPYTHON_BYPASS="manually managed python not supported by chrome operations"

# install dependencies
COPY install-deps.sh /install-deps.sh
RUN /install-deps.sh

WORKDIR /workdir

COPY ./src/* /src/
