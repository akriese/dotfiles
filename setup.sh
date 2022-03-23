# Execute this with zsh

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

echo "Reload your shell config now please!"

