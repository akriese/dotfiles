command -v nvim &> /dev/null && export MY_EDITOR='nvim' || export MY_EDITOR="vi -S $HOME/.vimrc"
export EDITOR=${MY_EDITOR:-vi}

export XDG_CONFIG_HOME="$HOME/.config"

grep -iq microsoft /proc/version && export WINUSR="/mnt/c/Users/Anton"

case "$SHELL" in
    *zsh*)
        export VERSIONED_RC="$ZDOTDIR/.zshrc"
        export LOCAL_RC="$HOME/.zshrc"
        ;;
    *bash*)
        export VERSIONED_RC="$DOTFILES/.allbashrc"
        export LOCAL_RC="$HOME/.bashrc"
        ;;
esac

if [[ -n $CODING ]]
then
        SCRIPTS="$CODING/Scripts"
        add_to_path "$SCRIPTS"
fi

command -v rg &> /dev/null && {
    export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --sort-files 2> /dev/null "
    export FZF_CTRL_T_COMMAND="rg --files --hidden --follow --sort-files 2> /dev/null "
    export FZF_ALT_C_COMMAND="rg --files --hidden --follow --sort-files --null 2> /dev/null | xargs -0 dirname | uniq"
} || {
    command -v ack &> /dev/null && {
        export FZF_DEFAULT_COMMAND="ack -f -s"
        export FZF_CTRL_T_COMMAND="ack -f -s"
    } || {
        export FZF_DEFAULT_COMMAND=""
        export FZF_CTRL_T_COMMAND=""
    }
}

