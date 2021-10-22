#!/bin/bash

source_cmd="source $(readlink -e .allbashrc)"
local_bashrc="$HOME/.bashrc"
if ! grep -q $source_cmd $local_bashrc;
then
	echo "$source_cmd" >> $local_bashrc
fi

stow tmux
stow nvim
stow vim

source $local_bashrc
