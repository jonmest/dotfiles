# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# ble.sh — fish-style autosuggestions, syntax highlighting, better completion.
# Must be sourced *before* any other interactive setup; the matching
# `ble-attach` call sits at the bottom of this file.
[ -f "$HOME/.local/share/blesh/ble.sh" ] && source "$HOME/.local/share/blesh/ble.sh" --noattach

# ---------------- History ----------------
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=10000
HISTFILESIZE=20000
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and grep
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Bash completion
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# ---------------- PATH ----------------
# Prepend a directory to PATH if it exists and isn't already there.
path_prepend() {
    case ":$PATH:" in
        *":$1:"*) ;;
        *) [ -d "$1" ] && PATH="$1:$PATH" ;;
    esac
}

path_prepend "$HOME/.local/bin"
path_prepend "$HOME/.nix-profile/bin"
path_prepend "$HOME/.cargo/bin"
path_prepend "$HOME/.bun/bin"
path_prepend "$HOME/.cabal/bin"
path_prepend "$HOME/.ghcup/bin"
path_prepend "$HOME/.local/share/pnpm"
path_prepend "$HOME/.lmstudio/bin"
path_prepend "$HOME/zig"
path_prepend "/home/linuxbrew/.linuxbrew/bin"
path_prepend "/home/linuxbrew/.linuxbrew/sbin"
path_prepend "$HOME/.sdkman/candidates/maven/current/bin"
path_prepend "$HOME/.sdkman/candidates/java/current/bin"
path_prepend "$HOME/.sdkman/candidates/gradle/current/bin"
path_prepend "/usr/local/go/bin"
path_prepend "/opt/nvim-linux-x86_64/bin"
path_prepend "/opt/homebrew/bin"
path_prepend "/opt/homebrew/sbin"
path_prepend "$HOME/.local/share/coursier/bin"
export PATH

# ---------------- Tool env vars ----------------
export BUN_INSTALL="$HOME/.bun"
export PNPM_HOME="$HOME/.local/share/pnpm"
export SDKMAN_DIR="$HOME/.sdkman"
export NVM_DIR="$HOME/.nvm"

if [ -d /home/linuxbrew/.linuxbrew ]; then
    export HOMEBREW_PREFIX=/home/linuxbrew/.linuxbrew
    export HOMEBREW_CELLAR=/home/linuxbrew/.linuxbrew/Cellar
    export HOMEBREW_REPOSITORY=/home/linuxbrew/.linuxbrew/Homebrew
fi

# CUDA — prefer the toolkit at /usr/local/cuda (a managed symlink) over
# /usr/bin/nvcc shipped by the OS package, which lags the real install.
if [ -x /usr/local/cuda/bin/nvcc ]; then
    export CUDA_PATH=/usr/local/cuda
    export CUDA_ROOT=/usr/local/cuda
    path_prepend "$CUDA_PATH/bin"
    export LD_LIBRARY_PATH="$CUDA_PATH/lib64${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
fi

# ---------------- Editor ----------------
export EDITOR=nvim
export VISUAL=nvim
export GIT_EDITOR="nvr --remote-wait +'set bufhidden=wipe'"

# ---------------- Aliases ----------------
alias vim="nvim"
alias ls="eza --icons --group-directories-first"
alias ll="eza --icons --group-directories-first -la"
alias lt="eza --icons --group-directories-first --tree --level=2"
alias gs="git status"
alias gss="git status -sb"
alias ga="git add"
alias gaa="git add -A"
alias gc="git commit"
alias gcm="git commit -m"
alias gca="git commit --amend --no-edit"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gsw="git switch"
alias gd="git diff"
alias gds="git diff --staged"
alias gp="git push"
alias gpf="git push --force-with-lease"
alias gpl="git pull --rebase"
alias gb="git branch"
alias gl="git log --oneline --graph --decorate -20"
alias gla="git log --oneline --graph --decorate --all -30"
alias gst="git stash"
alias gstp="git stash pop"
alias lg="lazygit"
alias cat="bat --style=plain"
alias catn="bat"

# Nav
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

alias buildrun='/home/jon/cses/build_run.sh'

# ---------------- Tool init ----------------
# nvm
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# Rust cargo env (idempotent)
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Homebrew shellenv (sets PATH/MANPATH/etc.; safe to run after our PATH setup)
if [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# opam
[ -r "$HOME/.opam/opam-init/init.sh" ] && . "$HOME/.opam/opam-init/init.sh" > /dev/null 2>&1

# zoxide (smart cd)
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init bash)"
fi

# atuin (shell history)
if command -v atuin >/dev/null 2>&1; then
    eval "$(atuin init bash)"
fi

# starship prompt (keep last so it wins on PS1)
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
fi

# SDKMAN must be sourced at the very end
[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ] && . "$SDKMAN_DIR/bin/sdkman-init.sh"

# After all tool inits, normalize PROMPT_COMMAND into an array so each hook
# (opam, zoxide, atuin, starship, ble.sh) runs as its own command instead of
# being glued together into one string with delimiter mismatches. Bash 5.1+
# runs every array element as a separate command. Splits on `;` to recover
# the individual hooks that were already concatenated by string-mode appends.
if declare -p PROMPT_COMMAND >/dev/null 2>&1 \
   && ! declare -p PROMPT_COMMAND 2>/dev/null | grep -q '^declare -a'; then
    _pc_str=$PROMPT_COMMAND
    unset PROMPT_COMMAND
    PROMPT_COMMAND=()
    # shellcheck disable=SC2086
    IFS=';' read -ra _pc_parts <<< "$_pc_str"
    for _pc_p in "${_pc_parts[@]}"; do
        _pc_p="${_pc_p#"${_pc_p%%[![:space:]]*}"}"  # ltrim
        _pc_p="${_pc_p%"${_pc_p##*[![:space:]]}"}"  # rtrim
        [ -n "$_pc_p" ] && PROMPT_COMMAND+=("$_pc_p")
    done
    unset _pc_str _pc_parts _pc_p
fi

# Attach ble.sh last, after all other setup has bound keys / set PROMPT_COMMAND.
[[ ${BLE_VERSION-} ]] && ble-attach
