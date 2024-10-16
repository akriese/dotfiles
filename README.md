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
export DOTFILES="$HOME/dotfiles"
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
Run `$DOTFILES/nvim_install.sh` which installs some dependencies (node, cargo, clipboard),
mostly user-locally. There will be errors on the first couple of starts, complaining about
missing Plugins etc.

Plugins and such will be installed by `lazy.nvim` and `mason`. There will probably errors
for missing tools, which you then have to add to make the errors go away.

### Oh My Posh setup
[oh-my-posh](https://ohmyposh.dev/) is a tool that beautifies the command prompt. This config includes a theme which shows
- distro pictogram
- current path (shortened or displayed as some emoji)
- git status
- python env and version
- node version
- last command's execution status (fail or success)
- time (the last command ended on)
- execution time (of the last command)
- battery status

I have chosen oh-my-posh as it also works on powershell. If you have a better alternative, feel free to contact me :)

Install the tool into `~/.local/bin/` with the script [omp\_setup.sh](omp_setup.sh) by running
```sh
bash "$DOTFILES/omp_setup.sh"
```
This automatically adds the installation path to PATH and the `oh-my-posh` eval command in either your local `~/.bashrc` or `~/.zshrc`.

### Git setup
To make use of the git config in `gitconfig.toml`, include the following in your global git config file:
```toml
[include]
    path = "~/path/to/dotfiles/gitconfig.toml"
```
