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
        if [[ -d "$ELEMENT" ]]
        then
            case "$ELEMENT" in
                zsh | oh-my-posh)
                    echo "Not stowing $ELEMENT"
                    ;;
                *)
                    stow -R "$ELEMENT"
                    ;;
            esac
        fi
    done
else
    echo "You might want to install 'stow' (e.g. sudo apt install stow)"
fi

verlte() { printf '%s\n%s' "$1" "$2" | sort -C -V }

[[ -x "tmux" ]] && verlte "$(tmux -V | cut -d' ' -f2)" "3.1" && ln -s "$HOME/.config/tmux/tmux.conf" "$HOME/.tmux.conf"


source "$local_bashrc"

command -v oh-my-posh || bash "$DOTFILES/omp_setup.sh"
