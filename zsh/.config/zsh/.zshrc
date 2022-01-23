#!/bin/sh
source "$DOTFILES/shell_settings.sh"
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=20000
SAVEHIST=10000
setopt notify
unsetopt extendedglob
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/anton/.zshrc'

autoload -Uz compinit
# End of lines added by compinstall
export ZDOTDIR=$HOME/.config/zsh
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
stty stop undef		# Disable ctrl-s to freeze terminal.
zle_highlight=('paste:none')
unsetopt BEEP

zstyle ':completion:*' menu select
zmodload zsh/complist
_comp_options+=(globdots)

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
compinit

autoload -Uz colors && colors
source "$ZDOTDIR/zsh-functions"

# Normal files to source
zsh_add_file "zsh-exports"
zsh_add_file "zsh-vim-mode"
zsh_add_file "zsh-aliases"
zsh_add_file "zsh-prompt"

# Plugins
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
zsh_add_plugin "hlissner/zsh-autopair"

eval "$(oh-my-posh --init --shell zsh --config "$DOTFILES/oh-my-posh/.oh-my-posh_theme.json")"
source $ZDOTDIR/zsh-alias
bindkey '^ ' autosuggest-accept

# Setup fzf
if [[ ! "$PATH" == */home/anton/.vim/plugged/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/anton/.vim/plugged/fzf/bin"
fi
[[ $- == *i* ]] && source "/home/anton/.vim/plugged/fzf/shell/completion.zsh" 2> /dev/null
source "/home/anton/.vim/plugged/fzf/shell/key-bindings.zsh"

