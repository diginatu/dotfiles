#!/bin/sh

FROMDIR=$HOME/dotfiles
DISTDIR=$HOME

# etc
ln -fs ${FROMDIR}/etc/bashrc ${DISTDIR}/.bashrc
ln -fs ${FROMDIR}/etc/profile ${DISTDIR}/.profile
ln -fs ${FROMDIR}/etc/qtvimrc ${DISTDIR}/.qtvimrc
ln -fs ${FROMDIR}/etc/zshenv ${DISTDIR}/.zshenv
ln -fs ${FROMDIR}/etc/zshprofile ${DISTDIR}/.zshprofile
ln -fs ${FROMDIR}/etc/zshrc ${DISTDIR}/.zshrc

# vim
mkdir -p ${DISTDIR}/.config/nvim/spell
mkdir -p ${DISTDIR}/.vim/
ln -fs ${FROMDIR}/vim/gvimrc ${DISTDIR}/.gvimrc
ln -fs ${FROMDIR}/vim/vimrc ${DISTDIR}/.vimrc
ln -fs ${FROMDIR}/vim/vimrc ${DISTDIR}/.config/nvim/init.vim
ln -fs ${FROMDIR}/vim/UltiSnips ${DISTDIR}/.vim/
ln -fs "${FROMDIR}/vim/spell/en.utf-8.add" ${DISTDIR}/.config/nvim/spell/

# nautilus
mkdir -p ${DISTDIR}/.local/share/nautilus/scripts/
ln -fs ${FROMDIR}/nautilus-scripts/* ${DISTDIR}/.local/share/nautilus/scripts/

mkdir -p ${DISTDIR}/.byobu/
ln -fs ${FROMDIR}/byobu/tmux.conf ${DISTDIR}/.byobu/.tmux.conf
ln -fs ${FROMDIR}/byobu/keybindings.tmux ${DISTDIR}/.byobu/keybindings.tmux
