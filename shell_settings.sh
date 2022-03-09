[[ -n $(command -v nvim) ]] && export MY_EDITOR='nvim' || export MY_EDITOR="vi -S $HOME/.vimrc"
export EDITOR=${MY_EDITOR:-vi}

[[ "$PATH" == *$HOME/.local/bin* ]] || export PATH="$HOME/.local/bin:$PATH"
export XDG_CONFIG_HOME="$HOME/.config"

grep -iq microsoft /proc/version && export WINUSR="/mnt/c/Users/Anton"

case "$SHELL" in
    *zsh*)
        export RC=$ZDOTDIR/.zshrc
        ;;
    *bash*)
        export RC=$HOME/.bashrc
        ;;
esac

if [[ -n $CODING ]]
then
        SCRIPTS=$CODING/Scripts
        [[ "$PATH" == *$SCRIPTS* ]] || export PATH="$SCRIPTS:$PATH"
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


