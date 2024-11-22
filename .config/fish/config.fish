set -gx LANG en_US
set -gx LC_ALL en_US.UTF-8
set -gx LC_COLLATE C
set -gx TERM xterm-256color
set -gx EDITOR nvim
set -gx SHELL /opt/homebrew/bin/fish

# fisher
set -g fisher_path $HOME/.local/share/fish/fisher
set fish_function_path $fish_function_path[1] $fisher_path/functions $fish_function_path[2..-1]
set fish_complete_path $fish_complete_path[1] $fisher_path/completions $fish_complete_path[2..-1]
for file in $fisher_path/conf.d/*.fish
    builtin source $file 2>/dev/null
end
if status is-interactive && ! functions --query fisher
    # curl --silent --location https://git.io/fisher | source && fisher install jorgebucaran/fisher
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
end

# Don't truncate the paths
set -g fish_prompt_pwd_dir_length 1
set -g fish_prompt_pwd_full_dirs 3

# homebrew
if test (uname -m) = arm64
    set -gx BREW_BASE /opt/homebrew
else
    set -gx BREW_BASE /usr/local
end

if test -e $BREW_BASE/bin/brew
    eval ($BREW_BASE/bin/brew shellenv)
end

set -gx LIBRARY_PATH $BREW_BASE/lib

# rust
if test -d $HOME/.cargo/bin
    fish_add_path $HOME/.cargo/bin
end

# java
set -gx JAVA_HOME (/usr/libexec/java_home)

if test -d $HOME/.jenv/bin
    fish_add_path $HOME/.jenv/bin
end

# node
set --universal nvm_default_version lts/jod

# docker
if test -d $HOME/.docker/bin
    fish_add_path $HOME/.docker/bin
end

# llvm
if test -d $BREW_BASE/opt/llvm/bin
    fish_add_path $BREW_BASE/opt/llvm/bin
end

# user binaries
if test -d $HOME/bin
    fish_add_path $HOME/bin
end

if test -d $HOME/.local/bin
    fish_add_path $HOME/.local/bin
end

# ripgrep config
set -gx RIPGREP_CONFIG_PATH $HOME/.config/ripgrep/ripgreprc

# Use ripgrep for fzf
set -gx FZF_DEFAULT_COMMAND rg --files
set -gx FZF_DEFAULT_OPTS '--color query:regular,hl:#E6A64C,hl+:bold:#E6A64C,prompt:#E0A8E1,bg+:#561E57,gutter:-1,info:#565B8F,separator:#262840,scrollbar:#565B8F'
set -gx FZF_PREVIEW_FILE_CMD "bat --style=numbers --color=always --line-range :500"
set -gx FZF_LEGACY_KEYBINDINGS 0

# aliases
alias ll="ls -alhG"
alias rm="rm -i"
alias mv="mv -i"
alias cp="cp -i"
alias ls="ls -G"
alias brewup="brew update; brew upgrade; brew cleanup; brew doctor"
alias glow="glow -s dark -p"
alias jo="joshuto"

if type -q eza
    alias ll "eza -l -g --git --color --icons"
    alias lla "ll -a"
end

set -gx EXA_COLORS "uu=0;33:gu=0;33:ur=0;33:uw=0;31"

if type -q zoxide
    zoxide init fish | source
end

if status is-interactive
    # Commands to run in interactive sessions can go here

    # Use vi key bindings instead of those disgusting emacs bindings
    fish_vi_key_bindings

    # I don't need any greeting for new shells
    set fish_greeting "Hello mate, welcome to Fish!"

    # Jenv
    jenv init - | source
    jenv enable-plugin export > /dev/null

end
