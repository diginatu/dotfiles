#!/bin/sh

. ./link_linux.sh

# etc
ln -fs ${FROMDIR}/etc/qtvimrc ${DISTDIR}/.qtvimrc

# nautilus
mkdir -p ${DISTDIR}/.local/share/nautilus/scripts/
ln -fs ${FROMDIR}/nautilus-scripts/* ${DISTDIR}/.local/share/nautilus/scripts/

# firefox
#FIREFOX_PROFILE_DIR=`find ${DISTDIR}/.mozilla/firefox/ -maxdepth 1 -type d -name '*default*' | head -1`
#if [[ ! $FIREFOX_PROFILE_DIR = "" ]]; then
    #mkdir -p ${FIREFOX_PROFILE_DIR}/chrome
    #ln -fs ${FROMDIR}/firefox/userContent.css ${FIREFOX_PROFILE_DIR}/chrome/
#fi
