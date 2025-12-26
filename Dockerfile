FROM ubuntu:22.04

ENV STM32CUBEIDE_VERSION=1.17.0
ENV DEBIAN_FRONTEND=noninteractive
ENV LICENSE_ALREADY_ACCEPTED=1
ENV TZ=Etc/UTC
ENV PATH="${PATH}:/opt/st/stm32cubeide_${STM32CUBEIDE_VERSION}"
ENV DEFAULT_APP="xclock"

RUN apt-get -y update && apt-get -y install --no-install-recommends \
    curl \
    zip \
    unzip \
    expect \
    wget \
    openjdk-21-jre \
    x11vnc \
    xvfb \
    gedit \
    git \
    python3 \
    python3-pip \
    cmake \
    g++ \
    curl \
    sudo \
    x11-apps \
    x11-utils \
    netcat-openbsd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install autobahn==20.12.3 cryptography==3.3.2

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get -y autoclean && \
    apt-get -y autoremove
