export EDITOR=${MY_EDITOR:-vi}

if [[ -n $CODING ]]
then
        SCRIPTS=$CODING/Scripts
        export PATH=$SCRIPTS:$PATH
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


