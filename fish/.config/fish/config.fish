# ~/.config/fish/config.fish
set -Ux PATH /opt/nvim-linux-x86_64/bin /home/jon/.ghcup /usr/local/go/bin/go $PATH

# Default editor
set -Ux EDITOR nvim
set -Ux VISUAL nvim
set -gx GIT_EDITOR "nvr --remote-wait +'set bufhidden=wipe'"

# Aliases
alias vim="nvim"
alias ls="eza --icons --group-directories-first"
alias ll="eza --icons --group-directories-first -la"
alias lt="eza --icons --group-directories-first --tree --level=2"
alias gs="git status"
alias lg="lazygit"
alias cat="bat --style=plain"
alias catn="bat"

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
