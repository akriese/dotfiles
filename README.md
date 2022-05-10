# dotfiles
These are my settings shared between different UNIX systems.
The programs and shells, that I have settings for are:
- Neovim
- shells
  - zsh
  - bash
- terminal mulitplexers / emulators
  - tmux
  - kitty
- htop
- oh-my-posh (command prompt styling)

To get started, clone this repo into your `$HOME` with
```sh
git clone git@github.com:akriese/dotfiles.git
```

### Shell setup
Depending on if you're using bash or zsh as your main shell, you have to create / adjust your local config files.
For bash:
```sh
SHELL="$(which bash)"
export DOTFILES="$HOME/dotfiles" # or wherever else you cloned it to
source "$DOTFILES/.allbashrc"
```

For zsh:
`~/.zshenv`
```sh
DOTFILES="$HOME/dotfiles"
ZDOTDIR="$DOTFILES/zsh/.config/zsh"
SHELL="$(which zsh)"
```

`~/.zshrc`
```sh
export PATH="path/to/neovim:$HOME/.local/bin:$PATH"
```

After setting up the config files, reload your shell session to make sure you have all the important changes.

### Stowing config files to `.config` and other settings folders
For this you need to have the tool [`stow`](https://www.gnu.org/software/stow/) installed. It maps this repo's tree
structure to the system's home folder structure using symlinks, thus placing config files where the programs (htop, tmux, nvim) are searching for them.
If stow is installed, run the [setup.sh](setup.sh) script. It automatically runs stow on all necessary subdirectories of this repo.
```sh
bash "$DOTFILES/setup.sh"
```

### Neovim setup
Firstly, neovim must be installed. Visit [neovim's](https://github.com/neovim/neovim) page to find help on that.
After installing Neovim, run it. There will be errors on the first couple of starts, complaining about missing Plugins etc.
Run `:PlugInstall` to install all configured plugins. Also run `:TSUpdate` to get the latest syntax files for treesitter.
