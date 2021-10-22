#!/bin/bash

# nodejs installieren (mit nvm)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
source $HOME/.bashrc
nvm install --lts

# python installieren
sudo apt install python3 python3-pip -y
python3 -m pip install --upgrade pip

#curl https://bootstrap.pypa.io/get-pip.py --output get-pip.py
#sudo python2 get-pip.py
#rm get-pip.py
python3 -m pip install --upgrade pylint jedi jedi-language-server neovim

# clangd installieren für coc
sudo apt install clangd -y

# general dependencies for installation
sudo apt install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip -y # for neovim installation

### CLIPBOARD FIX
# if WSL
if grep -q Microsoft /proc/version
  then
    curl -sLo /tmp/win32yank.zip https://github.com/equalsraf/win32yank/releases/download/v0.0.4/win32yank-x64.zip
    unzip -p /tmp/win32yank.zip win32yank.exe > /tmp/win32yank.exe
    chmod +x /tmp/win32yank.exe
    mv /tmp/win32yank.exe ~/.local/bin
  # if UNIX
  else
    sudo apt install xsel xclip -y # for neovim clipboard
fi

# ruby setup
sudo apt install ruby ruby-dev -y
gem install neovim

NEOVIM_DIR=~/Documents/neovim

mkdir -p $NEOVIM_DIR
git clone https://github.com/neovim/neovim.git $NEOVIM_DIR
cd $NEOVIM_DIR
git checkout release-0.5
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install

# coc settings

# was tun, wenn es keine SUDO rechte gibt?

