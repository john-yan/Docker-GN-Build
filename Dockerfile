FROM ubuntu:16.04

ENV PATH=$PATH:/buildtools

RUN apt-get update && \
    apt-get install -y python \
                       pkg-config \
                       libnss3-dev \
                       libcups2-dev \
                       git \
                       vim \
                       libglib2.0-dev \
                       libpango1.0-dev \
                       libgconf2-dev \
                       libgnome-keyring-dev \
                       libatk1.0-dev \
                       libgtk-3-dev \
                       $(apt-cache search gcc-multilib | awk '{print $1}') \
                       $(apt-cache search g++-multilib | awk '{print $1}')

RUN git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git /depot_tools
ENV PATH=$PATH:/depot_tools

WORKDIR /workdir

COPY ./src/* /srcdir/

