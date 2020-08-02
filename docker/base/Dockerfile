FROM ubuntu:latest AS base

ENV DEBIAN_FRONTEND noninteractive
ENV LANG en_US.UTF-8
ENV TZ Asia/Tokyo

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends --fix-missing \
    build-essential \
    ca-certificates \
    git \
    zsh \
    fuse \
    wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Neovim
RUN CUSTOM_NVIM_PATH=/usr/local/bin/nvim.appimage && \
    wget https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -O "${CUSTOM_NVIM_PATH}" && \
    chmod +x "${CUSTOM_NVIM_PATH}" && \
    update-alternatives --install /usr/bin/ex ex "${CUSTOM_NVIM_PATH}" 110 && \
    update-alternatives --install /usr/bin/vi vi "${CUSTOM_NVIM_PATH}" 110 && \
    update-alternatives --install /usr/bin/view view "${CUSTOM_NVIM_PATH}" 110 && \
    update-alternatives --install /usr/bin/vim vim "${CUSTOM_NVIM_PATH}" 110 && \
    update-alternatives --install /usr/bin/vimdiff vimdiff "${CUSTOM_NVIM_PATH}" 110

