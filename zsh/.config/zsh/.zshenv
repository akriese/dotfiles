echo "sourced versioned zshenv"
export SHELL="$(which zsh)"

[[ -f "$HOME/.zshenv" ]] && source "$HOME/.zshenv"
