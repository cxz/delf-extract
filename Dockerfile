FROM nvidia/cuda:9.0-devel-ubuntu16.04
MAINTAINER Alexandre Maia <alexandre.maia@gmail.com>

RUN apt-get update -y && apt-get install -y \
        libopenblas-dev \
        python-numpy \
        python-dev \
        swig \
        git \
        python-pip \
        wget && \
    rm -rf /var/lib/apt/lists/*

RUN pip install matplotlib && \
    pip install future && \    
    pip install numpy && \        
    pip install scikit-image && \
    pip install scipy && \
    pip install tensorflow-gpu && \
    rm -rf /root/.cache/pip/*
    
