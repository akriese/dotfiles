#!/bin/bash

OHMYPOSH_THEME=${OHMYPOSH_THEME:-"$DOTFILES/oh-my-posh/.oh-my-posh_theme.json"}
INSTALL_DIR="$HOME/.local/bin"
local_rc=${LOCAL_RC:-"$HOME/.bashrc"}

if [[ ! -e "$OHMYPOSH_THEME" ]];
then
    echo "Theme does not exist at $OHMYPOSH_THEME"
    exit 1
fi

if [[ ! -d "$INSTALL_DIR" ]];
then
    echo "Creating installation directory $INSTALL_DIR..."
    mkdir -p "$INSTALL_DIR"
fi


command -v oh-my-posh &> /dev/null && {
    echo "Programm already installed... Want to reinstall / update? [y/N]"
    read answer
    case $answer in
        "" | "n" | "N" | "no" | "No")
            exit 0
            ;;
    esac
}

echo "Installing oh-my-posh to $INSTALL_DIR..."
case $(uname -m) in
    armv7l)
        link="https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-arm"
        ;;
    x86_64)
        link="https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64"
        ;;
    *)
        echo "Your architecture ($(uname -m)) has not yet been handled by this script. Please visit the page"
        echo "https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/ to find your version."
        exit 1
        ;;
esac

wget "$link" -O "$INSTALL_DIR/oh-my-posh"
chmod +x "$INSTALL_DIR/oh-my-posh"

echo "Adding eval command to shell config ($local_rc)..."
case "$SHELL" in
    *zsh*)
        CONFIG_COMMAND='eval "$(oh-my-posh --init --shell zsh --config "'$OHMYPOSH_THEME'")"'
        ;;
    *bash*)
        CONFIG_COMMAND='eval "$(oh-my-posh --init --shell bash --config "'$OHMYPOSH_THEME'")"'
        ;;
esac

! grep -q "$CONFIG_COMMAND" "$local_rc" && echo "$CONFIG_COMMAND" >> "$local_rc"

echo "Adding $INSTALL_DIR to PATH..."
SHELL_EXPORTS="$DOTFILES/shell_settings.sh"
EXPORT_COMMAND='export PATH='$INSTALL_DIR':$PATH'
! grep -q "$INSTALL_DIR" <<< "$PATH" && echo "$EXPORT_COMMAND" >> "$SHELL_EXPORTS"

