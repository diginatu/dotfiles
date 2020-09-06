FROM archlinux:latest AS base

ENV LANG en_US.UTF-8
ENV TZ Asia/Tokyo
ENV TERM xterm-256color

RUN mkdir ~/bin ~/code

RUN sed -i '/^NoExtract/d' /etc/pacman.conf && \
    pacman -Syu --noconfirm \
        man-db \
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
        fzf && \
    chsh -s /usr/bin/zsh

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
