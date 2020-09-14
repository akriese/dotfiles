# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias cod='cd $CODING'
alias xc='xcalib -invert -alter'
alias agi='sudo apt-get install'
alias lsS='ls -Shal'
alias lsa='ls -la'
alias gandalf='firefox -new-window "https://www.youtube.com/watch?v=G1IbRujko-A"'
alias hsghci="cd $CODING/Haskell && ghci"
alias vim='vim -S ~/.vimrc'
alias vi='vim'
alias temp='vcgencmd measure_temp'
alias pissh='ssh -X pi@192.168.178.152'
alias lncrna="ssh -c aes128-gcm@openssh.com -XCY -J kriea97@andorra.imp.fu-berlin.de kriea97@lncrna.imp.fu-berlin.de"
alias rotate='xrandr -o'
alias pdf='evince'
alias img='eog'
alias vim_rc='vim $CODING/dotfiles/.vimrc'
alias bash_rc='vim $HOME/.bashrc'
alias jena='ssh -XY -J biprak6@login.fmi.uni-jena.de biprak6@zwoa.bioinf.uni-jena.de'

