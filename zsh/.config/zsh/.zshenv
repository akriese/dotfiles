SHELL="$(which zsh)"
[[ -f "$HOME/.zshenv" ]] && [[ -z "$ZDOTDIR" ]] && source "$HOME/.zshenv"

ZDOTDIR="${ZDOTDIR:-$(basename $(print -P %N))}"


