#!/usr/bin/env bash
# Re-stow all dotfile packages from this repo into $HOME.
# Run after pulling or adding new packages.
set -euo pipefail

cd "$(dirname "$(readlink -f "$0")")"

packages=(wezterm fish starship nvim bat git lazygit fontconfig)

for pkg in "${packages[@]}"; do
  if [ -d "$pkg" ]; then
    stow -R "$pkg"
    echo "restowed $pkg"
  fi
done

# vscode: stow on linux, manual symlink on macOS
if [ -d "vscode" ]; then
  if [ "$(uname)" = "Darwin" ]; then
    vscode_dir="$HOME/Library/Application Support/Code/User"
    mkdir -p "$vscode_dir"
    ln -sf "$PWD/vscode/.config/Code/User/settings.json" "$vscode_dir/settings.json"
    [ -f "$PWD/vscode/.config/Code/User/keybindings.json" ] && \
      ln -sf "$PWD/vscode/.config/Code/User/keybindings.json" "$vscode_dir/keybindings.json"
    echo "linked vscode (macOS)"
  else
    stow -R vscode
    echo "restowed vscode"
  fi
fi
