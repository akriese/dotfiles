# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'

alias rcsrc='source ~/.bashrc'
[[ -x /usr/bin/python3.8 ]] && alias python3='/usr/bin/python3.8'
alias python='python3'
alias cod='cd $CODING'
alias xc='xcalib -invert -alter'
alias agi='sudo apt-get install'
alias lsS='ls -Shal'
alias gandalf='firefox -new-window "https://www.youtube.com/watch?v=G1IbRujko-A"'
alias hsghci="cd $CODING/Haskell && ghci"
[[ -n $(command -v nvim) ]] && MY_EDITOR='nvim' || MY_EDITOR='vi -S ~/.vimrc'
alias vim=$MY_EDITOR
alias temp='vcgencmd measure_temp'
alias rotate='xrandr -o'
alias pdf='evince'
alias img='eog'
alias vim_rc='vim $DOTFILES/nvim/.config/nvim/init.vim'
alias bash_rc='vim $HOME/.bashrc'
alias pubip='curl https://ipinfo.io/ip'
alias lesss='less -S'
alias htopu='htop --user $(whoami)'
alias open='xdg-open'

export MY_EDITOR

pc () {
  python -c "print($1)"
}

tmux_update_display() {
    export DISPLAY="$(tmux show-env | grep ^DISPLAY | sed -n 's/^DISPLAY=//p')"
}

[[ -n "$TMUX" ]] && tmux_update_display
