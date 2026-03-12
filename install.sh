#!/usr/bin/env bash
set -euo pipefail

# Dotfiles installer
# Usage: ./install.sh [--no-packages]
#
# Sets up a fresh system with:
#   - Required packages and CLI tools
#   - Config files via GNU Stow
#   - Nerd Font (JetBrainsMono)

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
SKIP_PACKAGES=false

for arg in "$@"; do
  case "$arg" in
    --no-packages) SKIP_PACKAGES=true ;;
  esac
done

info()  { printf "\033[1;34m::\033[0m %s\n" "$1"; }
ok()    { printf "\033[1;32m::\033[0m %s\n" "$1"; }
warn()  { printf "\033[1;33m::\033[0m %s\n" "$1"; }
error() { printf "\033[1;31m::\033[0m %s\n" "$1"; }

# ---------- Detect OS ----------
if [ -f /etc/os-release ]; then
  . /etc/os-release
  DISTRO="$ID"
elif command -v brew &>/dev/null; then
  DISTRO="macos"
else
  DISTRO="unknown"
fi

# ---------- Package installation ----------
install_packages() {
  info "Installing system packages..."

  case "$DISTRO" in
    ubuntu|debian|pop|linuxmint)
      sudo apt update
      sudo apt install -y git stow fish curl unzip fontconfig
      ;;
    fedora)
      sudo dnf install -y git stow fish curl unzip fontconfig
      ;;
    arch|manjaro|endeavouros)
      sudo pacman -Syu --noconfirm git stow fish curl unzip fontconfig
      ;;
    macos)
      brew install git stow fish curl
      ;;
    *)
      warn "Unknown distro '$DISTRO' — install git, stow, fish, curl manually"
      return
      ;;
  esac

  ok "System packages installed"
}

install_rust_tools() {
  # Ensure cargo is available
  if ! command -v cargo &>/dev/null; then
    info "Installing Rust toolchain..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
    ok "Rust installed"
  fi

  local tools=(eza bat git-delta zoxide starship difftastic just)
  for tool in "${tools[@]}"; do
    local bin_name="$tool"
    # Map package names to binary names
    case "$tool" in
      git-delta) bin_name="delta" ;;
      difftastic) bin_name="difft" ;;
    esac

    if command -v "$bin_name" &>/dev/null; then
      ok "$bin_name already installed"
    else
      info "Installing $tool..."
      cargo install "$tool"
      ok "$tool installed"
    fi
  done
}

install_lazygit() {
  if command -v lazygit &>/dev/null; then
    ok "lazygit already installed"
    return
  fi

  info "Installing lazygit..."
  local version
  version=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')

  local arch
  arch=$(uname -m)
  case "$arch" in
    x86_64) arch="x86_64" ;;
    aarch64|arm64) arch="arm64" ;;
  esac

  local os
  os=$(uname -s)

  local tmp
  tmp="$(mktemp -d)"
  curl -fsSL "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${version}_${os}_${arch}.tar.gz" -o "$tmp/lazygit.tar.gz"
  tar -xf "$tmp/lazygit.tar.gz" -C "$tmp" lazygit
  mv "$tmp/lazygit" "$HOME/.cargo/bin/lazygit"
  chmod +x "$HOME/.cargo/bin/lazygit"
  rm -rf "$tmp"
  ok "lazygit installed"
}

install_nerd_font() {
  local font_dir="$HOME/.local/share/fonts"
  if fc-list | grep -qi "JetBrainsMono Nerd Font"; then
    ok "JetBrainsMono Nerd Font already installed"
    return
  fi

  info "Installing JetBrainsMono Nerd Font..."
  mkdir -p "$font_dir"
  local tmp
  tmp="$(mktemp -d)"
  curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz" -o "$tmp/jbm.tar.xz"
  tar -xf "$tmp/jbm.tar.xz" -C "$font_dir"
  rm -rf "$tmp"
  fc-cache -fv
  ok "JetBrainsMono Nerd Font installed"
}

# ---------- Stow configs ----------
stow_configs() {
  info "Linking config files with stow..."
  cd "$DOTFILES_DIR"

  local packages=(wezterm fish starship nvim bat git lazygit)
  for pkg in "${packages[@]}"; do
    if [ -d "$pkg" ]; then
      # Remove conflicting files before stowing
      stow --adopt "$pkg" 2>/dev/null || true
      # Restore our versions (adopt pulls existing files in, then we reset)
      git checkout -- "$pkg" 2>/dev/null || true
      stow -R "$pkg"
      ok "Stowed $pkg"
    fi
  done
}

# ---------- Set default shell ----------
set_fish_shell() {
  if [ "$SHELL" = "$(which fish)" ]; then
    ok "Fish is already the default shell"
    return
  fi

  local fish_path
  fish_path="$(which fish)"

  if ! grep -qx "$fish_path" /etc/shells; then
    info "Adding fish to /etc/shells..."
    echo "$fish_path" | sudo tee -a /etc/shells
  fi

  info "Setting fish as default shell..."
  chsh -s "$fish_path"
  ok "Default shell set to fish (restart your session to take effect)"
}

# ---------- Main ----------
main() {
  info "Dotfiles installer"
  echo "  Dotfiles dir: $DOTFILES_DIR"
  echo "  OS: $DISTRO"
  echo ""

  if [ "$SKIP_PACKAGES" = false ]; then
    install_packages
    install_rust_tools
    install_lazygit
    install_nerd_font
  else
    warn "Skipping package installation (--no-packages)"
    if ! command -v stow &>/dev/null; then
      error "GNU Stow is required. Install it and re-run."
      exit 1
    fi
  fi

  stow_configs
  set_fish_shell

  echo ""
  ok "All done! Open a new terminal to see the changes."
  info "If using wezterm, it will auto-reload."
  info "For neovim, run :Lazy sync on first launch."
}

main "$@"
