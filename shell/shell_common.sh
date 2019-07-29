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

if type 'trash-put' > /dev/null; then
    alias rm='echo "Do you mean tp?"'
    alias tp='trash-put'
fi
alias g='git'

# Open
if type 'xdg-open' > /dev/null; then
    alias open='xdg-open'
fi

alias ghopen="open \`git remote -v | awk '/fetch/{print \$2}' | sed -Ee 's@:@/@' -e 's#(git@|git://)#https://#'\`"
alias ghurl="echo \`git remote -v | awk '/fetch/{print \$2}' | sed -Ee 's@:@/@' -e 's#(git@|git://)#https://#'\`"

# Clipboard
if type xclip > /dev/null; then
    alias clip='xclip -sel c'
    alias clipo='xclip -o -sel c'
fi
if type xsel > /dev/null; then
    alias clip='xsel -bi'
    alias clipo='xsel -bo'
fi
if type pbcopy > /dev/null; then
    alias clip=pbcopy
    alias clipo=pbpaste
fi


if type nvim > /dev/null; then
    alias vim=nvim
fi
alias sudo='sudo '

if ! [ -z ${TMUX} ]; then
    alias fixssh='export $(tmux showenv SSH_AUTH_SOCK)'
    $fixssh
fi

# Disable Ctrl-S
if [[ -t 0 ]]; then
    stty stop undef
    stty start undef
fi

# added by travis gem
[ -f ~/.travis/travis.sh ] && source ~/.travis/travis.sh

#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
