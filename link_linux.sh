#!/bin/sh

. ./link_config.sh

mkdir -p ${DISTDIR}/.local/share

# shell
ln -fs ${FROMDIR}/shell/bashrc ${DISTDIR}/.bashrc
ln -fs ${FROMDIR}/shell/profile ${DISTDIR}/.profile
ln -fs ${FROMDIR}/shell/zshenv ${DISTDIR}/.zshenv
ln -fs ${FROMDIR}/shell/zshprofile ${DISTDIR}/.zshprofile
ln -fs ${FROMDIR}/shell/zshrc ${DISTDIR}/.zshrc

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
