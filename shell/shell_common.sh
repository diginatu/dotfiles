# aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias sumn='paste -sd+ - | bc'

alias ll='ls -alhF'
alias la='ls -A'
alias l='ls -CF'

alias rm='echo "Do you mean tp?"'
alias tp='trash-put'
alias sudo='sudo '

if ! [ -z ${TMUX} ]; then
    alias fixssh='export $(tmux showenv SSH_AUTH_SOCK)'
    $fixssh
fi
