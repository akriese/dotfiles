[[ -n $(command -v nvim) ]] && export MY_EDITOR='nvim' || export MY_EDITOR="vi -S $HOME/.vimrc"
export EDITOR=${MY_EDITOR:-vi}

export XDG_CONFIG_HOME="$HOME/.config"

grep -iq microsoft /proc/version && export WINUSR="/mnt/c/Users/Anton"

case "$SHELL" in
    *zsh*)
        VERSIONED_RC="$ZDOTDIR/.zshrc"
        LOCAL_RC="$HOME/.zshrc"
        ;;
    *bash*)
        VERSIONED_RC="$DOTFILES/.allbashrc"
        LOCAL_RC="$HOME/.bashrc"
        ;;
esac

if [[ -n $CODING ]]
then
        SCRIPTS="$CODING/Scripts"
        add_to_path "$SCRIPTS"
fi

if [[ -x "$(command -v rg)" ]]
then
        export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --sort-files 2> /dev/null "
        export FZF_CTRL_T_COMMAND="rg --files --hidden --follow --sort-files 2> /dev/null "
        export FZF_ALT_C_COMMAND="rg --files --hidden --follow --sort-files --null 2> /dev/null | xargs -0 dirname | uniq"
elif [[ -x "$(command -v ack)" ]]
then
        export FZF_DEFAULT_COMMAND="ack -f -s"
        export FZF_CTRL_T_COMMAND="ack -f -s"
else
        export FZF_DEFAULT_COMMAND=""
        export FZF_CTRL_T_COMMAND=""
fi


