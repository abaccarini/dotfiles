My dotfiles, consisting of config files for the following programs:
- Neovim
- Kitty
- zsh
- oh-my-zsh
- Zathura
- tmux
- lazygit
- latexindent
- Hammerspoon (macOS)
- Karabiner-Elements (macOS)

## Setup

The same `master` is used on every machine (macOS and Linux):

```sh
git clone git@github.com:abaccarini/dotfiles.git ~/dotfiles
~/dotfiles/install.sh          # link everything into $HOME, write per-machine files
~/dotfiles/install.sh --check  # after a pull: report missing links, tools, plugins
```

Anything specific to one machine goes in untracked files, which the tracked config loads if present:

| File | Loaded by | For |
| --- | --- | --- |
| `~/.gitconfig.local` | `.gitconfig` (after the shared settings) | email, `user.signingkey`, `gpg.ssh.program` |
| `~/.zshrc.local` | end of `.zshrc` | `SSH_AUTH_SOCK`, aliases for local paths |
| `.config/nvim/lua/local/rust_features.lua` | `lua/plugins/rust.lua` | cargo features per project (gitignored) |

The tracked `.gitconfig` signs with 1Password at its Linux path. On a Mac that uses 1Password, put this in `~/.gitconfig.local`:

```gitconfig
[gpg "ssh"]
	program = /Applications/1Password.app/Contents/MacOS/op-ssh-sign
```
