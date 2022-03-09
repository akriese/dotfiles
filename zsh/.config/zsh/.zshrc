#!/bin/sh
source "$DOTFILES/shell_settings.sh"
source "$ZDOTDIR/zsh-options"

HISTFILE="$HOME/.histfile"
HISTSIZE=20000
SAVEHIST=10000

autoload -Uz compinit
stty stop undef		# Disable ctrl-s to freeze terminal.
zle_highlight=('paste:none')

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
[[ -f "$HOME/.zshrc" ]] && source "$HOME/.zshrc"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
