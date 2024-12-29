# @profiling enable the following when you want to see what is taking a long
#            time to load.  To use:
#   - Change this file
#   - Reload by running `exec zsh`
#   - Run `zprof` to see the results
#
# and another way to track this is
#
#   - /usr/bin/time zsh -i -c exit
#   - for i in $(seq 1 10); do /usr/bin/time /bin/zsh -i -c exit; done;
#
# zmodload zsh/zprof

# benchmark zsh
alias zsh-time="time zsh -i -c exit"
alias zsh-debug="time ZSH_DEBUG=1 zsh -i -c exit"
if [[ -n "$ZSH_DEBUG" ]]; then
  zmodload zsh/zprof
fi

export TERM="xterm-256color"
export EDITOR=nvim

# language
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

setopt prompt_subst
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
autoload bashcompinit && bashcompinit
autoload -Uz compinit
compinit
source <(kubectl completion zsh)
complete -C '/usr/local/bin/aws_completer' aws

# history options
export HISTFILE=$HOME/.zsh_history
export HISTSIZE=50000
export SAVEHIST=$HISTSIZE
export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)"
setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt append_history
setopt share_history

# export
function addToPath {
  PATH="$1:$PATH"
}

addToPath $HOME/bin

# starship
eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# ripgrep
export RIPGREP_CONFIG_PATH="~/.config/ripgrep/ripgreprc"
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
# export FZF_DEFAULT_OPTS='--reverse --no-separator --color query:regular,hl:#E6A64C,hl+:bold:#E6A64C,prompt:#E0A8E1,bg+:#561E57,gutter:-1,info:#565B8F,separator:#262840,scrollbar:#565B8F'
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--multi"

# zoxide
eval "$(zoxide init zsh)"

# alias
alias ls="ls -G"
alias ll="ls -alh"
alias lll="ls -alhTOe@"
alias rm="rm -i"
alias mv="mv -i"
alias cp="cp -i"

if type eza >/dev/null; then
	alias ll='eza -l --git --icons=auto'
	alias la='eza -la --git --icons=auto'
	alias tree='eza --tree --git --icons=auto'
fi

if type bat >/dev/null; then
  alias cat='bat'
fi

# zsh plugins
source $HOME/.config/zsh/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey '^w' autosuggest-execute
bindkey '^e' autosuggest-accept
bindkey '^u' autosuggest-toggle
bindkey '^L' vi-forward-word
bindkey '^k' up-line-or-search
bindkey '^j' down-line-or-search

# rust
if [[ -d "$HOME/.cargo" ]]; then
  addToPath $HOME/.cargo/bin
fi

# java
# Try to find jenv, if it's not on the path
export JENV_ROOT="${JENV_ROOT:=${HOME}/.jenv}"
if ! type jenv > /dev/null && [ -f "${JENV_ROOT}/bin/jenv" ]; then
    export PATH="${JENV_ROOT}/bin:${PATH}"
fi

# Lazy load jenv
if type jenv > /dev/null; then
    export PATH="${JENV_ROOT}/bin:${JENV_ROOT}/shims:${PATH}"
    function jenv() {
        unset -f jenv
        eval "$(command jenv init -)"
        jenv $@
    }
fi


# pyenv
# Try to find pyenv, if it's not on the path
export PYENV_ROOT="${PYENV_ROOT:=${HOME}/.pyenv}"
if ! type pyenv > /dev/null && [ -f "${PYENV_ROOT}/bin/pyenv" ]; then
    export PATH="${PYENV_ROOT}/bin:${PATH}"
fi

# Lazy load pyenv
if type pyenv > /dev/null; then
    export PATH="${PYENV_ROOT}/bin:${PYENV_ROOT}/shims:${PATH}"
    function pyenv() {
        unset -f pyenv
        eval "$(command pyenv init -)"
        if [[ -n "${ZSH_PYENV_LAZY_VIRTUALENV}" ]]; then
            eval "$(command pyenv virtualenv-init -)"
        fi
        pyenv $@
    }
fi


# Node Version Manager 
# export NVM_DIR="$HOME/.config/nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


export NVM_DIR="$HOME/.config/nvm"
nvm() {
    echo "Lazy loading nvm..."

    unfunction "$0"

    [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

    $0 "$@"
}

lazynvm() {
	unset -f nvm
	export NVM_DIR="$HOME/.config/nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
}
nvm() {
  lazynvm
  nvm $@
}
node() {
  lazynvm
  node $@
}
npm() {
  lazynvm
  npm $@
}
npx() {
  lazynvm
  npm $@
}

# # Automatically switch Node version if .nvmrc found
# autoload -U add-zsh-hook

# load-nvmrc() {
#   local nvmrc_path
#   nvmrc_path="$(nvm_find_nvmrc)"

#   if [ -n "$nvmrc_path" ]; then
#     local nvmrc_node_version
#     nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

#     if [ "$nvmrc_node_version" = "N/A" ]; then
#       nvm install > /dev/null
#     elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
#       nvm use > /dev/null
#     fi
#   elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
#     nvm use default > /dev/null
#   fi
# }

# add-zsh-hook chpwd load-nvmrc
# load-nvmrc

# # default Shell(zsh) => tmux => zsh
# if [[ $SHLVL == 1 && $TMUX == "" ]]; then
#   echo -n "attach?(y/n/x): " && read attach
#   echo $attach

#   if [[ $attach == "x" ]]; then
#     return
#   fi

#   # try attache tmux when connect via ssh
#   if [[ $attach == "y" && "${SSH_CONNECTION-}" != "" ]]; then
#     tmux a -d || tmux
#   else
#     tmux
#   fi
# fi

# fzf
function fzf-history-selection() {
    BUFFER=`history -n 1 | tail -r  | awk '!a[$0]++' | fzf`
    CURSOR=$#BUFFER
    zle reset-prompt
}

zle -N fzf-history-selection
bindkey '^R' fzf-history-selection






function dev() {
    moveto=$(ghq root)/$(ghq list | fzf)
    cd $moveto

    # rename session if in tmux
    if [[ ! -z ${TMUX} ]]
    then
        repo_name=${moveto##*/}
        tmux rename-session ${repo_name//./-}
    fi
}


if [[ -n "$ZSH_DEBUG" ]]; then
  zprof
fi
