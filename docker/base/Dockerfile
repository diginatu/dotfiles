FROM archlinux:latest

ENV LANG en_US.UTF-8
ENV TZ Asia/Tokyo
ENV TERM xterm-256color
ENV RPROMPT='docker:base'

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
        python-pynvim \
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
    nvim '+PlugInstall' '+qa' && \
    nvim '+CocInstall -sync coc-json coc-ultisnips' '+qa'

CMD cd ~/code && /usr/bin/zsh
