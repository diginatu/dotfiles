#!/bin/sh

. ./link_linux.sh

# etc
ln -fs ${FROMDIR}/etc/qtvimrc ${DISTDIR}/.qtvimrc

# nautilus
mkdir -p ${DISTDIR}/.local/share/nautilus/scripts/
ln -fs ${FROMDIR}/nautilus-scripts/* ${DISTDIR}/.local/share/nautilus/scripts/

ln -fs ${FROMDIR}/etc/xbindkeysrc ${DISTDIR}/.xbindkeysrc
