#!/bin/sh
export SHELL=$(which zsh)
export ZDOTDIR=${ZDOTDIR:-"$HOME/.config/zsh"}
source "$DOTFILES/shell_settings.sh"
HISTFILE=~/.histfile
HISTSIZE=20000
SAVEHIST=10000
setopt notify
unsetopt extendedglob
bindkey -e

autoload -Uz compinit
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
unsetopt EXTENDED_HISTORY
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

autoload -Uz colors && colors
source "$ZDOTDIR/zsh-functions"

# Normal files to source
zsh_add_file "zsh-exports"
zsh_add_file "zsh-aliases"
[[ -x $(which oh-my-posh) ]] || zsh_add_file "zsh-prompt"
#zsh_add_file "zsh-vim-mode"

# Plugins
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
zsh_add_plugin "zsh-users/zsh-completions"
zsh_add_plugin "hlissner/zsh-autopair"
compinit

source $ZDOTDIR/zsh-alias

# keybindings
noop () { }
zle -N noop
bindkey '^ ' autosuggest-accept
bindkey '^H' backward-kill-word
bindkey '^K' kill-line
bindkey '^[[3~' delete-char
bindkey '^[[3;5~' kill-word
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey '\e' noop
bindkey '\e[[3;5~' noop
