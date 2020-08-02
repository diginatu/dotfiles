#!/bin/sh

. ./link_config.sh

mkdir -p ${DISTDIR}/.local/share

# Shell
ln -fs ${FROMDIR}/shell/bashrc_mac.bash ${DISTDIR}/.bashrc
ln -fs ${FROMDIR}/shell/profile_mac.bash ${DISTDIR}/.profile
ln -fs ${FROMDIR}/shell/profile_mac.bash ${DISTDIR}/.bash_profile
ln -fs ${FROMDIR}/shell/zshenv_mac.zsh ${DISTDIR}/.zshenv
ln -fs ${FROMDIR}/shell/zprofile_mac.zsh ${DISTDIR}/.zprofile
ln -fs ${FROMDIR}/shell/zshrc_mac.zsh ${DISTDIR}/.zshrc

# Vim
mkdir -p ${DISTDIR}/.config/nvim/spell
mkdir -p ${DISTDIR}/.vim/spell
ln -fs ${FROMDIR}/vim/gvimrc ${DISTDIR}/.gvimrc
ln -fs ${FROMDIR}/vim/vimrc ${DISTDIR}/.vimrc
ln -fs ${FROMDIR}/vim/vimrc ${DISTDIR}/.config/nvim/init.vim
ln -fs ${FROMDIR}/vim/UltiSnips ${DISTDIR}/.vim/
ln -fs ${FROMDIR}/vim/UltiSnips ${DISTDIR}/.config/nvim/
ln -fs ${FROMDIR}/vim/coc-settings.json ${DISTDIR}/.vim/
ln -fs ${FROMDIR}/vim/coc-settings.json ${DISTDIR}/.config/nvim/
ln -fs "${FROMDIR}/vim/spell/en.utf-8.add" ${DISTDIR}/.config/nvim/spell/
ln -fs "${FROMDIR}/vim/spell/en.utf-8.add" ${DISTDIR}/.vim/spell/

# Tmux
ln -fs ${FROMDIR}/etc/tmux.conf ${DISTDIR}/.tmux.conf

# Other
mkdir -p ${DISTDIR}/.config/peco
ln -fs ${FROMDIR}/etc/peco_config.json ${DISTDIR}/.config/peco/config.json
sudo mkdir -p /var/root/.docker
sudo ln -fs ${FROMDIR}/docker/config.json /var/root/.docker/config.json
ln -fs ${FROMDIR}/docker/config.json ${DISTDIR}/.docker/config.json
