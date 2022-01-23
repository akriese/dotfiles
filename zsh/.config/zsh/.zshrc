#!/bin/sh
source "$DOTFILES/shell_settings.sh"
export ZDOTDIR=$HOME/.config/zsh
HISTFILE=~/.histfile
HISTSIZE=20000
SAVEHIST=10000
setopt notify
unsetopt extendedglob
bindkey -v

autoload -Uz compinit
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
