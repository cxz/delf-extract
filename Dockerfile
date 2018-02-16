FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04
MAINTAINER Alexandre Maia <alexandre.maia@gmail.com>

#why is it missing?    
ENV CUDNN_VERSION 7.0.5.15    
RUN apt-get update && apt-get install -y --no-install-recommends \
            libcudnn7=$CUDNN_VERSION-1+cuda9.0 \
            libcudnn7-dev=$CUDNN_VERSION-1+cuda9.0 && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
        unzip \
        curl \
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
    
COPY . /delf-extract
WORKDIR /delf-extract

#DELF from tensorflow models/research
ENV TF_MODELS_REVISION 4c05414826e87f3b8ef05
ENV TENSORFLOW_MODELS_ROOT models

RUN git clone https://github.com/tensorflow/models.git $TENSORFLOW_MODELS_ROOT && \
    cd models && git checkout $TF_MODELS_REVISION && cd .. && \
    pip install -e $TENSORFLOW_MODELS_ROOT/research/slim && \
    pip install -e $TENSORFLOW_MODELS_ROOT/research/delf && \
    mkdir -p tmp && wget https://github.com/google/protobuf/releases/download/v3.3.0/protoc-3.3.0-linux-x86_64.zip -O protoc.zip && unzip protoc.zip -d tmp && \
    tmp/bin/protoc --proto_path=$TENSORFLOW_MODELS_ROOT/research/delf $TENSORFLOW_MODELS_ROOT/research/delf/delf/protos/*.proto --python_out=$TENSORFLOW_MODELS_ROOT/research/delf && \
    rm -r tmp && rm protoc.zip && \
    wget http://download.tensorflow.org/models/delf_v1_20171026.tar.gz && \
    mkdir -p parameters && tar xf delf_v1_20171026.tar.gz -C parameters && \
    rm delf*tar.gz
    
ENV PYTHONPATH /delf-extract/$TENSORFLOW_MODELS_ROOT/research:$PYTHONPATH






