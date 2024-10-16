#!/bin/bash

nvim_version_to_install=${1:-v0.10.2}

function check_cmd {
    command -v ${1} &>/dev/null
}

# install node.js
check_cmd node || {
    # if nvm is not installed yet, install it
    check_cmd nvm || {
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
        source ${LOCAL_RC}
    }

    nvm install --lts
}

### CLIPBOARD FIX
# if WSL
if grep -q -i Microsoft /proc/version
then
    if [[ ! -x /usr/local/bin/win32yank.exe ]]; then
        echo "Installing win32yank32.exe..."
        curl -sLo /tmp/win32yank.zip https://github.com/equalsraf/win32yank/releases/download/v0.1.1/win32yank-x64.zip
        unzip -p /tmp/win32yank.zip win32yank.exe > /tmp/win32yank.exe
        chmod +x /tmp/win32yank.exe
        sudo mv /tmp/win32yank.exe /usr/local/bin
    fi
    # if UNIX
else
    sudo apt install xsel xclip -y # for neovim clipboard
fi

check_cmd cargo || {
    echo Install cargo to install nvim and other dependencies.
    exit 1
}

cargo install bob-nvim

bob install ${nvim_version_to_install}
bob use ${nvim_version_to_install}

# append bob nvim path to PATH in local shell config file
echo 'export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"' >> ${LOCAL_RC}



