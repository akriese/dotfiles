# Run this in admin mode
# but first, install choco

# install ohmyposh
winget install JanDeDobbeleer.OhMyPosh -s winget

# install fzf
choco install fzf
Install-Module PSFzf

# install things for nvim
choco install make llvm git ripgrep

# only do this if you dont build neovim from source
# choco install neovim -pre

# password manager setup
winget install gpg4win
choco install pass-winmenu

# load profile for helper functions
. $DOTFILES\powershell\profile.ps1

mklink "C:\tools\pass-winmenu\pass-winmenu.yaml" "$DOTFILES\pass-winmenu.yaml"
