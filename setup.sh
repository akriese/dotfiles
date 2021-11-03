#!/bin/bash

source_cmd="source $(readlink -e .allbashrc)"
local_bashrc="$HOME/.bashrc"
echo $source_cmd
if ! grep -q "$source_cmd" "$local_bashrc";
then
	echo "$source_cmd" >> "$local_bashrc"
fi

if [[ -x $(command -v stow) ]]
then
    for ELEMENT in *
    do
        if [[ -d $ELEMENT ]]
        then
            stow -R $ELEMENT
        fi
    done
else
    echo "You might want to install 'stow' (e.g. sudo apt install stow)"
fi

source "$local_bashrc"
