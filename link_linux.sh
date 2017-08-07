#!/bin/sh

source ./link_config.sh

# etc
mkdir -p ${DISTDIR}/.local/share
ln -fs ${FROMDIR}/etc/bashrc ${DISTDIR}/.bashrc
ln -fs ${FROMDIR}/etc/profile ${DISTDIR}/.profile
ln -fs ${FROMDIR}/etc/zshenv ${DISTDIR}/.zshenv
ln -fs ${FROMDIR}/etc/zshprofile ${DISTDIR}/.zshprofile
ln -fs ${FROMDIR}/etc/zshrc ${DISTDIR}/.zshrc

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
