#!/usr/bin/env bash
# Link these dotfiles into $HOME and check that this machine has what they expect.
#   ./install.sh          create missing links (anything in the way is moved to <name>.bak-<time>)
#   ./install.sh --check  only report
# Exits 1 if anything needs attention. Works with macOS's bash 3.2.
set -euo pipefail

repo=$(cd "$(dirname "$0")" && pwd)
check=false
if [[ ${1-} == --check ]]; then check=true; fi
problems=0
warn() {
  printf '  ! %s\n' "$*"
  problems=$((problems + 1))
}

# Each entry is a path under both $HOME and the repo, or <path in $HOME>=<path in repo>.
links=(.zshrc .gitconfig .tmux.conf
  .config/nvim .config/kitty .config/lazygit .config/fd .config/lsd
  .config/latexindent .config/zathura .config/helix)
if [[ $(uname -s) == Darwin ]]; then
  # latexindent only looks in ~/Library/Preferences on macOS.
  links+=(.hammerspoon Library/Preferences/latexindent=.config/latexindent)
fi

echo "Links"
for rel in "${links[@]}"; do
  src=$repo/${rel#*=}
  dst=$HOME/${rel%%=*}
  if [[ $dst -ef $src ]]; then
    continue
  elif $check; then
    warn "$dst is not linked to $src"
  else
    if [[ -e $dst || -L $dst ]]; then
      bak=$dst.bak-$(date +%Y%m%d-%H%M%S)
      mv "$dst" "$bak"
      echo "  moved the old $dst to $bak"
    fi
    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst"
    echo "  linked $dst"
  fi
done

echo "Per-machine files"
# latexindent doesn't expand ~ in indentconfig.yaml, so it is written per machine (gitignored).
indentconfig=$repo/.config/latexindent/indentconfig.yaml
want=$(printf '# Written by install.sh: latexindent does not expand ~, so this is per machine.\npaths:\n  - %s\n' \
  "$HOME/.config/latexindent/settings.yaml")
if [[ ! -f $indentconfig || $(cat "$indentconfig") != "$want" ]]; then
  if $check; then
    warn "$indentconfig is missing or for another machine (run ./install.sh)"
  else
    printf '%s\n' "$want" >"$indentconfig"
    echo "  wrote $indentconfig"
  fi
fi

echo "Tools"
for tool in git zsh nvim fzf zoxide delta lsd latexindent; do
  command -v "$tool" >/dev/null || warn "$tool is not installed"
done
kitty=$(command -v kitty || true)
if [[ -z $kitty && -x /Applications/kitty.app/Contents/MacOS/kitty ]]; then
  kitty=/Applications/kitty.app/Contents/MacOS/kitty
fi
if [[ -z $kitty ]]; then
  warn "kitty is not installed"
else
  version=$("$kitty" --version | awk '{print $2}')
  minor=${version#0.}
  minor=${minor%%.*}
  if [[ $version == 0.* && $minor -lt 47 ]]; then
    warn "kitty $version is older than 0.47, so kitty.conf's auto_reload_config is an unknown option"
  fi
fi
omz=$HOME/.oh-my-zsh
if [[ ! -d $omz ]]; then
  warn "oh-my-zsh is not installed at $omz"
else
  for plugin in $(sed -n '/^plugins=(/,/^)/p' "$repo/.zshrc" | grep -vE '^[[:space:]]*(#|plugins=\(|\))' || true); do
    [[ -d $omz/plugins/$plugin || -d $omz/custom/plugins/$plugin ]] ||
      warn "oh-my-zsh plugin $plugin is not installed"
  done
fi

echo "Git signing"
# Read from / so this repo's own .git/config doesn't count; includes are followed.
program=$(cd / && git config --get gpg.ssh.program || true)
program=${program:-ssh-keygen}
command -v "$program" >/dev/null ||
  warn "commits are signed with $program, which isn't here: set gpg.ssh.program in ~/.gitconfig.local"
key=$(cd / && git config --get user.signingkey || true)
case $key in
'~/'* | /*)
  [[ -f ${key/#\~/$HOME} ]] || warn "user.signingkey $key doesn't exist: set it in ~/.gitconfig.local"
  ;;
esac

echo "Machine-local files (untracked, optional)"
for f in "$HOME/.gitconfig.local" "$HOME/.zshrc.local" "$repo/.config/nvim/lua/local/rust_features.lua"; do
  if [[ -e $f ]]; then echo "  have $f"; else echo "  none $f"; fi
done

if ((problems)); then
  echo "$problems thing(s) need attention"
  exit 1
fi
echo "All good"
