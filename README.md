# dotfiles

Personal development environment with a unified warm color palette inspired by Claude's UI.

![Shell: fish](https://img.shields.io/badge/shell-fish-blue)
![Terminal: wezterm](https://img.shields.io/badge/terminal-wezterm-orange)
![Editor: neovim](https://img.shields.io/badge/editor-neovim-green)

## Quick start

```bash
git clone https://github.com/jonmest/dotfiles ~/dotfiles
cd ~/dotfiles
./install.sh
```

The install script handles everything: system packages, Rust CLI tools, nerd fonts, symlinks, and setting fish as the default shell. Use `--no-packages` to skip installs and only symlink configs.

## What's included

| Directory | Config for | Highlights |
|-----------|-----------|------------|
| `wezterm/` | WezTerm terminal | Light font weight, custom color scheme, subpixel AA, borderless window |
| `fish/` | Fish shell | Aliases for eza/bat/lazygit, zoxide + starship init |
| `starship/` | Starship prompt | Minimal layout, warm palette, terracotta prompt character |
| `nvim/` | Neovim | Custom `claude` colorscheme, LSP, treesitter, telescope, lualine |
| `bat/` | bat (cat replacement) | Syntax highlighting theme |
| `git/` | Git | Delta pager with themed diffs, zdiff3 merge conflicts |
| `lazygit/` | Lazygit | Themed UI, delta integration |

## CLI tools

Installed via the setup script:

| Tool | Replaces | What it does |
|------|----------|-------------|
| [eza](https://github.com/eza-community/eza) | `ls` | Icons, git status, tree view |
| [bat](https://github.com/sharkdp/bat) | `cat` | Syntax highlighting |
| [delta](https://github.com/dandavison/delta) | `git diff` | Beautiful diffs with syntax highlighting |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | `cd` | Smart directory jumping |
| [starship](https://starship.rs) | prompt | Fast, customizable prompt |
| [lazygit](https://github.com/jesseduffield/lazygit) | — | TUI git client |
| [difftastic](https://github.com/Wilfred/difftastic) | `diff` | Structural, syntax-aware diffs |
| [just](https://github.com/casey/just) | `make` | Modern task runner |

## Color palette

A warm, dark theme used consistently across all tools:

| Role | Hex | |
|------|-----|---|
| Background | `#1A1714` | ![#1A1714](https://placehold.co/16x16/1A1714/1A1714) |
| Foreground | `#E8E0D8` | ![#E8E0D8](https://placehold.co/16x16/E8E0D8/E8E0D8) |
| Accent (terracotta) | `#D97757` | ![#D97757](https://placehold.co/16x16/D97757/D97757) |
| Green | `#7DAE82` | ![#7DAE82](https://placehold.co/16x16/7DAE82/7DAE82) |
| Yellow | `#D4A857` | ![#D4A857](https://placehold.co/16x16/D4A857/D4A857) |
| Blue | `#7B9EBF` | ![#7B9EBF](https://placehold.co/16x16/7B9EBF/7B9EBF) |
| Magenta | `#B588B0` | ![#B588B0](https://placehold.co/16x16/B588B0/B588B0) |
| Cyan | `#6FAFAF` | ![#6FAFAF](https://placehold.co/16x16/6FAFAF/6FAFAF) |

## How it works

Configs are managed with [GNU Stow](https://www.gnu.org/software/stow/). Each directory mirrors the home directory structure:

```
dotfiles/
├── wezterm/.wezterm.lua        → ~/.wezterm.lua
├── fish/.config/fish/          → ~/.config/fish/
├── nvim/.config/nvim/          → ~/.config/nvim/
└── ...
```

To re-stow after pulling changes:

```bash
cd ~/dotfiles
stow -R wezterm fish starship nvim bat git lazygit vscode
```

## Fish aliases

| Alias | Command |
|-------|---------|
| `ls` | `eza --icons --group-directories-first` |
| `ll` | `eza --icons --group-directories-first -la` |
| `lt` | `eza --icons --group-directories-first --tree --level=2` |
| `cat` | `bat --style=plain` |
| `lg` | `lazygit` |
| `gs` | `git status` |
| `z` | zoxide (smart cd) |
