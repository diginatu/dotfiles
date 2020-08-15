FROM archlinux:latest AS base

ENV LANG en_US.UTF-8
ENV TZ Asia/Tokyo

RUN mkdir ~/bin ~/code

RUN pacman -Syu --noconfirm \
    base-devel \
    neovim \
    git \
    zsh \
    tmux \
    go \
    python \
    python-pip \
    nodejs \
    npm \
    wget \
    fzf

# dotfiles
RUN git clone https://github.com/diginatu/dotfiles.git ~/dotfiles && \
    cd ~/dotfiles && \
    sh link_linux.sh

# Neovim
RUN mkdir -p ~/.config/nvim/autoload/ && \
    mkdir -p ~/.config/nvim/plugged/ && \
    wget https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -O ~/.config/nvim/autoload/plug.vim && \
    sudo pip install neovim && \
    nvim '+PlugInstall' '+qa' && \
    nvim '+CocInstall -sync coc-json coc-ultisnips' '+qa'

CMD cd ~/code && /usr/bin/zsh
