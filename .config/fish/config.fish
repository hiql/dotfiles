set -gx LANG en_US
set -gx LC_ALL en_US.UTF-8
set -gx LC_COLLATE C
set -gx TERM xterm-256color

# Editor should nvim
set -gx EDITOR nvim

# Shell
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

# Colors for Fish shell
set -l comment 768390
set -l selection 29414f
# Shell highlight groups
# (https://fishshell.com/docs/current/interactive.html#variables-color)

set -g fish_color_normal brwhite # Default text
set -g fish_color_command brwhite # 'cd', 'ls', 'echo'
# set -g fish_color_keyword red  # 'if'   NOTE: default = $fish_color_command
set -g fish_color_quote green # "foo" in 'echo "foo"'
# set -g fish_color_redirection magenta  # '>/dev/null'   NOTE: default = magenta
# set -g fish_color_end blue  # ; in 'cmd1; cmd2'   NOTE: default = blue
# set -g fish_color_error red  # incomplete / non-existent commands   NOTE: default = red
set -g fish_color_param blue # xvf in 'tar xvf', --all in 'ls --all'
set -g fish_color_comment $comment # '# a comment' # Question: Where does default come from if not set?
# set -g fish_color_selection --background=$selection # Run 'fish_vi_key_bindings', type some text, <Esc> then 'v' to select text
set -g fish_color_operator red # * in 'ls ./*'
# set -g fish_color_escape cyan  # ▆ in 'echo ▆' NOTE: default = cyan
set -g fish_color_autosuggestion $comment # Appended virtual text, e.g. 'cd  ' displaying 'cd ~/some/path'
# set -g fish_color_search_match --background=red   # TODO: How to trigger?

set -g fish_pager_color_completion $fish_color_param # List of suggested items for 'ls <Tab>'
set -g fish_pager_color_description green # (command) in list of commands for 'c<Tab>'
set -g fish_pager_color_prefix red --underline # Leading 'c' in list of completions for 'c<Tab>'
set -g fish_pager_color_progress brwhite # '…and nn more rows' for 'c<Tab>'
set -g fish_pager_color_selected_background --background=$selection # Cursor when <Tab>ing through 'ls <Tab>'

# homebrew
if test (uname -m) = arm64
    set -gx BREW_BASE /opt/homebrew
else
    set -gx BREW_BASE /usr/local
end

if test -e $BREW_BASE/bin/brew
    eval ($BREW_BASE/bin/brew shellenv)
end

# rust
if test -d $HOME/.cargo/bin
    fish_add_path $HOME/.cargo/bin
end

# java
set -gx JAVA_HOME (/usr/libexec/java_home)

if test -d $HOME/.jenv/bin
    fish_add_path $HOME/.jenv/bin
end

# go
set -gx GOPATH $HOME/go
set -gx GOPROXY https://goproxy.io,direct
set -gx GOPRIVATE "github.com/hiql/*"
fish_add_path $GOPATH/bin

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

set -gx LIBRARY_PATH $BREW_BASE/lib


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
    set fish_greeting ""

    # Jenv
    jenv init - | source
    jenv enable-plugin export > /dev/null

end
