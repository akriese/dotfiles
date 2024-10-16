# Execute this with zsh

command -v stow &> /dev/null && {
    for ELEMENT in *
    do
        if [[ -d "$ELEMENT" ]]
        then
            case "$ELEMENT" in
                zsh | oh-my-posh | powershell)
                    echo "Not stowing $ELEMENT"
                    ;;
                *)
                    stow -R "$ELEMENT"
                    ;;
            esac
        fi
    done
} || {
    echo "You might want to install 'stow' (e.g. sudo apt install stow)"
}

verlte() { printf '%s\n%s' "$1" "$2" | sort -C -V; }

command -v tmux &> /dev/null && verlte "$(tmux -V | cut -d' ' -f2)" "3.1" && ln -s "$HOME/.config/tmux/tmux.conf" "$HOME/.tmux.conf"


_gitconfig_append="
[include]
    path = $DOTFILES/gitconfig.toml
"
echo "$_gitconfig_append" >> $HOME/.gitconfig

echo "Reload your shell config now please!"
