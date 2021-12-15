#!/bin/bash

OHMYPOSH_THEME=${OHMYPOSH_THEME:-$HOME/.oh-my-posh_theme.json}
INSTALL_DIR="$HOME/.local/bin"
RC="$HOME/.bashrc"

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


if [[ -n $(command -v oh-my-posh) ]];
then
    echo "Programm already installed... Want to reinstall / update? [y/N]"
    read answer
    case $answer in
        "" | "n" | "N" | "no" | "No")
            exit 0
            ;;
    esac
fi

echo "Installing oh-my-posh to $INSTALL_DIR..."
wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O "$INSTALL_DIR/oh-my-posh"
chmod +x "$INSTALL_DIR/oh-my-posh"

echo "Adding eval command to .bashrc..."
CONFIG_COMMAND='eval "$(oh-my-posh --init --shell bash --config "'$OHMYPOSH_THEME'")"'
! grep -q "$CONFIG_COMMAND" "$RC" && echo "$CONFIG_COMMAND" >> "$RC"

echo "Adding $INSTALL_DIR to PATH..."
EXPORT_COMMAND='export PATH='$INSTALL_DIR':$PATH'
! grep -q "$INSTALL_DIR" <<< "$PATH" && echo "$EXPORT_COMMAND" >> "$RC"

