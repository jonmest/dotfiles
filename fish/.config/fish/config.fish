# ~/.config/fish/config.fish

# Inherit paths that bash gets from ~/.bashrc and /etc/profile.
# --global keeps startup from mutating fish's universal variables.
for p in \
    $HOME/.local/bin \
    $HOME/.npm-global/bin \
    $HOME/.cargo/bin \
    $HOME/.bun/bin \
    $HOME/.cabal/bin \
    $HOME/.ghcup/bin \
    $HOME/.local/share/pnpm \
    $HOME/.lmstudio/bin \
    $HOME/zig \
    /home/linuxbrew/.linuxbrew/bin \
    /home/linuxbrew/.linuxbrew/sbin \
    $HOME/.sdkman/candidates/maven/current/bin \
    $HOME/.sdkman/candidates/java/current/bin \
    $HOME/.sdkman/candidates/gradle/current/bin \
    /usr/local/go/bin \
    /opt/nvim-linux-x86_64/bin \
    /opt/homebrew/bin \
    /opt/homebrew/sbin
    test -d $p; and fish_add_path --global --move $p
end

set -gx BUN_INSTALL $HOME/.bun
set -gx PNPM_HOME $HOME/.local/share/pnpm
set -gx SDKMAN_DIR $HOME/.sdkman

if test -d /home/linuxbrew/.linuxbrew
    set -gx HOMEBREW_PREFIX /home/linuxbrew/.linuxbrew
    set -gx HOMEBREW_CELLAR /home/linuxbrew/.linuxbrew/Cellar
    set -gx HOMEBREW_REPOSITORY /home/linuxbrew/.linuxbrew/Homebrew
end

set -gx NVM_DIR $HOME/.nvm

function __nvm_use_version --argument-names node_version
    test -n "$node_version"; or return 1
    test "$node_version" != none; or return 1

    set -l node_bin "$NVM_DIR/versions/node/$node_version/bin"
    test -d $node_bin; or return 1

    set -l next_path
    for p in $PATH
        if not string match -q "$NVM_DIR/versions/node/*/bin" $p
            set next_path $next_path $p
        end
    end

    set -gx PATH $node_bin $next_path
    set -gx NVM_BIN $node_bin
    set -gx NVM_INC "$NVM_DIR/versions/node/$node_version/include/node"
end

function __nvm_resolve_version --argument-names spec
    test -n "$spec"; or return 1

    # Follow alias chain (e.g. default -> lts/* -> v20.11.0)
    set -l seen
    while test -f "$NVM_DIR/alias/$spec"
        contains -- $spec $seen; and return 1
        set seen $seen $spec
        set spec (string trim (cat "$NVM_DIR/alias/$spec"))
        test -n "$spec"; or return 1
    end

    # Already a full installed version
    if test -d "$NVM_DIR/versions/node/$spec"
        echo $spec
        return 0
    end

    # Prefix match (e.g. "26" -> "v26.1.0", "20.11" -> "v20.11.3")
    set -l needle (string replace -r '^v' '' -- $spec)
    set -l match (find "$NVM_DIR/versions/node" -mindepth 1 -maxdepth 1 -type d -printf "%f\n" 2>/dev/null \
        | string match -r "^v$needle(\\..*)?\$" \
        | sort -V | tail -n 1)
    test -n "$match"; and echo $match; and return 0
    return 1
end

function __nvm_default_version
    if test -s "$NVM_DIR/alias/default"
        set -l v (__nvm_resolve_version (string trim (cat "$NVM_DIR/alias/default")))
        test -n "$v"; and echo $v; and return 0
    end

    find "$NVM_DIR/versions/node" -mindepth 1 -maxdepth 1 -type d -printf "%f\n" 2>/dev/null | sort -V | tail -n 1
end

if test -d "$NVM_DIR"
    __nvm_use_version (__nvm_default_version)
end

function nvm --description "Node Version Manager"
    test -s "$NVM_DIR/nvm.sh"; or begin
        echo "nvm: $NVM_DIR/nvm.sh not found" >&2
        return 1
    end

    set -l output (bash -c 'source "$NVM_DIR/nvm.sh"; nvm "$@"; status=$?; printf "\n__NVM_VERSION__=%s\n" "$(nvm current 2>/dev/null)"; exit $status' nvm $argv 2>&1)
    set -l nvm_status $status

    for line in $output
        if string match -q "__NVM_VERSION__=*" $line
            set -l node_version (string replace "__NVM_VERSION__=" "" $line)
            __nvm_use_version $node_version
        else
            echo $line
        end
    end

    return $nvm_status
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

status is-interactive; and fish_add_path --global --move ~/.ghcup/bin


# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
test -r '/home/jon/.opam/opam-init/init.fish' && source '/home/jon/.opam/opam-init/init.fish' > /dev/null 2> /dev/null; or true
# END opam configuration

# >>> coursier install directory >>>
test -d /home/jon/.local/share/coursier/bin; and fish_add_path --global --append /home/jon/.local/share/coursier/bin
# <<< coursier install directory <<<

if test -d "$NVM_DIR"
    __nvm_use_version (__nvm_default_version)
end

test -r '/home/jon/.opam/opam-init/init.fish' && source '/home/jon/.opam/opam-init/init.fish' > /dev/null 2> /dev/null; or true
