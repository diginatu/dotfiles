#!/bin/sh

. ./link_config.sh

mkdir -p ${DISTDIR}/.local/share

# Shell
ln -fs ${FROMDIR}/shell/bashrc ${DISTDIR}/.bashrc
ln -fs ${FROMDIR}/shell/profile ${DISTDIR}/.profile
ln -fs ${FROMDIR}/shell/profile ${DISTDIR}/.bash_profile
ln -fs ${FROMDIR}/shell/zshenv ${DISTDIR}/.zshenv
ln -fs ${FROMDIR}/shell/zprofile ${DISTDIR}/.zprofile
ln -fs ${FROMDIR}/shell/zshrc ${DISTDIR}/.zshrc

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
rm ${DISTDIR}/.gitconfig
cp ${FROMDIR}/etc/gitconfig ${DISTDIR}/.gitconfig

if [[ $EUID -eq 0 ]] ; then
    mkdir -p /root/.docker
    ln -fs ${FROMDIR}/docker/config.json /root/.docker/config.json
else
    sudo mkdir -p /root/.docker
    sudo ln -fs ${FROMDIR}/docker/config.json /root/.docker/config.json
fi

mkdir -p ${DISTDIR}/.docker
ln -fs ${FROMDIR}/docker/config.json ${DISTDIR}/.docker/config.json
