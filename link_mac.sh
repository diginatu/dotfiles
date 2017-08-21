#!/bin/sh

. ./link_config.sh

mkdir -p ${DISTDIR}/.local/share

# shell
ln -fs ${FROMDIR}/shell/bashrc_mac.bash ${DISTDIR}/.bashrc
ln -fs ${FROMDIR}/shell/profile_mac.bash ${DISTDIR}/.profile
ln -fs ${FROMDIR}/shell/zshenv_mac.zsh ${DISTDIR}/.zshenv
ln -fs ${FROMDIR}/shell/zshprofile ${DISTDIR}/.zshprofile
ln -fs ${FROMDIR}/shell/zshrc_mac.zsh ${DISTDIR}/.zshrc

# vim
mkdir -p ${DISTDIR}/.config/nvim/spell
mkdir -p ${DISTDIR}/.vim/spell
ln -fs ${FROMDIR}/vim/gvimrc ${DISTDIR}/.gvimrc
ln -fs ${FROMDIR}/vim/vimrc ${DISTDIR}/.vimrc
ln -fs ${FROMDIR}/vim/vimrc ${DISTDIR}/.config/nvim/init.vim
ln -fs ${FROMDIR}/vim/UltiSnips ${DISTDIR}/.vim/
ln -fs "${FROMDIR}/vim/spell/en.utf-8.add" ${DISTDIR}/.config/nvim/spell/
ln -fs "${FROMDIR}/vim/spell/en.utf-8.add" ${DISTDIR}/.vim/spell/

# tmux
ln -fs ${FROMDIR}/etc/tmux.conf ${DISTDIR}/.tmux.conf
