FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -yq --no-install-recommends \
     software-properties-common gpg-agent\
     && add-apt-repository -y ppa:alex-p/tesseract-ocr-devel \
     && apt install -y tesseract-ocr-all \
     && apt update \
     && apt clean && \
     rm -rf /var/lib/apt/lists/*
