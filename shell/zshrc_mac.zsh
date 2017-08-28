source ~/dotfiles/shell/zshrc

# pyenv
if [ -d "$HOME/.pyenv" ] ; then
    export PYENV_ROOT="$HOME/.pyenv"
    PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
fi

alias ls='ls -G'
alias vim='nvim'
alias tp='trash'
