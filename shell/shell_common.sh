# aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias sumn='paste -sd+ - | bc'

alias ll='ls -alhF'
alias la='ls -A'
alias l='ls -CF'

# gradle wrapper
alias gr='gradle'
alias gradle='./gradlew'

if type 'gio' > /dev/null; then
    alias rm='echo "Do you mean tp?"'
    alias tp='gio trash'
fi
alias g='git'
alias kub='kubectl'
alias sys='systemctl'
alias 'ghq get'='ghq get -l'
alias 'ghq clone'='ghq clone -l'

# Kitty
if type 'kitten' > /dev/null; then
    alias clip='kitten clipboard'
    alias clipo='kitten clipboard --get'
fi

# Open
if type 'xdg-open' > /dev/null; then
    alias open='xdg-open'
fi

# Clipboard
if type xsel > /dev/null; then
    alias clip='xsel -bi'
    alias clipo='xsel -bo'
elif type xclip > /dev/null; then
    alias clip='xclip -sel c'
    alias clipo='xclip -o -sel c'
elif type wl-copy > /dev/null; then
    alias clip=wl-copy
    alias clipo=wl-paste
elif type pbcopy > /dev/null; then
    alias clip=pbcopy
    alias clipo=pbpaste
fi


if type nvim > /dev/null; then
    alias vim=nvim
    export EDITOR='nvim'
fi
alias sudo='sudo '
alias nohup='nohup '

if ! [ -z ${TMUX} ]; then
    alias fixssh='export $(tmux showenv SSH_AUTH_SOCK)'
    $fixssh
fi

# Disable Ctrl-S
if [[ -t 0 ]]; then
    stty stop undef
    stty start undef
fi

alias 1='cd ..'
alias 2='cd ../..'
alias 3='cd ../../..'
alias 4='cd ../../../..'
alias 5='cd ../../../../..'
alias 6='cd ../../../../../..'
alias 7='cd ../../../../../../..'
alias 8='cd ../../../../../../../..'
alias 9='cd ../../../../../../../../..'
