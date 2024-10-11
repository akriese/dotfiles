#!/bin/sh
source "$DOTFILES/shell_functions.sh"

[[ -f "$HOME/.zshrc" ]] && source "$HOME/.zshrc"

source "$DOTFILES/shell_settings.sh"
source "$ZDOTDIR/zsh-options"

HISTFILE="$HOME/.histfile"
HISTSIZE=20000
SAVEHIST=10000

autoload -Uz compinit
stty stop undef         # Disable ctrl-s to freeze terminal.
zle_highlight=('paste:none')

zstyle ':completion:*' menu select
zmodload zsh/complist
_comp_options+=(globdots)

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
autoload -z edit-command-line
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
zle -N edit-command-line

autoload -Uz colors && colors
source "$ZDOTDIR/zsh-functions"
source "$ZDOTDIR/zsh-alias"

# Normal files to source
zsh_add_file "zsh-exports"
zsh_add_file "zsh-aliases"
if [[ ! -x $(which oh-my-posh) ]]
then
    zsh_add_file "zsh-prompt"
fi

# Plugins
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
zsh_add_plugin "zsh-users/zsh-completions"
zsh_add_plugin "hlissner/zsh-autopair"
compinit

source "$ZDOTDIR/zsh-keybinds"

command -v fzf &> /dev/null && {
    # zsh fzf config is sourced differently from 0.44.0 on
    verlte $(fzf --version) "0.44.0" \
        && {[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh} \
        || source <(fzf --zsh)
}
