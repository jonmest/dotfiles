# ~/.config/fish/config.fish

# Inherit paths that bash/zsh get from /etc/profile
# Only adds if the directory exists and isn't already in PATH
for p in /opt/homebrew/bin /opt/homebrew/sbin /usr/local/bin /usr/local/go/bin /opt/nvim-linux-x86_64/bin $HOME/.cargo/bin $HOME/.local/bin $HOME/.ghcup/bin
    test -d $p; and not contains $p $PATH; and fish_add_path $p
end

# Default editor
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx GIT_EDITOR "nvr --remote-wait +'set bufhidden=wipe'"

# Aliases
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

# Zoxide (smarter cd)
if type -q zoxide
    zoxide init fish | source
end

# Atuin (better shell history)
if type -q atuin
    atuin init fish | source
end

# Launch starship prompt if installed
if type -q starship
    starship init fish | source
end

status is-interactive; and fish_add_path ~/.ghcup/bin


# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
test -r '/home/jon/.opam/opam-init/init.fish' && source '/home/jon/.opam/opam-init/init.fish' > /dev/null 2> /dev/null; or true
# END opam configuration

# pnpm
set -gx PNPM_HOME "/home/jon/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# >>> coursier install directory >>>
set -gx PATH "$PATH:/home/jon/.local/share/coursier/bin"
# <<< coursier install directory <<<
