# benchmark zsh
alias zsh-time="time zsh -i -c exit"
alias zsh-debug="time ZSH_DEBUG=1 zsh -i -c exit"
if [[ -n "$ZSH_DEBUG" ]]; then
  zmodload zsh/zprof
fi

# general
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export EDITOR="vim"
export VISUAL=$EDITOR
export PAGER="less -F -X"

# history
export HISTFILE=$HOME/.zsh_history
export HISTSIZE=50000
export SAVEHIST=$HISTSIZE
export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)"
setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt append_history
setopt share_history

# vi mode
bindkey -v
export KEYTIMEOUT=1

# export
function addToPath {
  PATH="$1:$PATH"
}

# user binaries
addToPath $HOME/bin

# homebrew
[[ -x /opt/homebrew/bin/brew ]] && eval $(/opt/homebrew/bin/brew shellenv)
[[ -x /usr/local/bin/brew ]] && eval $(/usr/local/bin/brew shellenv)

# completion
setopt prompt_subst
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu select
zstyle ':completion:*' list-suffixes
zstyle ':completion:*' expand prefix suffix

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
fi

autoload bashcompinit && bashcompinit
autoload -Uz compinit
compinit

if type kubectl > /dev/null; then
  source <(kubectl completion zsh)
fi

if type docker > /dev/null; then
  source <(docker completion zsh)
fi

# Load known hosts file for auto-completion with ssh and scp commands
if [ -f ~/.ssh/known_hosts ]; then
  zstyle ':completion:*' hosts $( sed 's/[, ].*$//' $HOME/.ssh/known_hosts )
  zstyle ':completion:*:*:(ssh|scp):*:*' hosts `sed 's/^\([^ ,]*\).*$/\1/' ~/.ssh/known_hosts`
fi

export LSCOLORS='gxfxcxdxbxegedabagacad'
export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32'

# completion colours
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# starship
eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# ripgrep
export RIPGREP_CONFIG_PATH="~/.config/ripgrep/ripgreprc"
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
export FZF_DEFAULT_OPTS=" \
--color=query:regular \
--color=bg+:#313244,spinner:#f5e0dc,hl:#f38ba8,border:#45475a \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f9e2af \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:bold:#f38ba8 \
--color=selected-bg:#313244 \
--color=gutter:-1 \
--height 100% \
--border=rounded \
--multi"
export FZF_CTRL_T_OPTS='--preview "bat  --color=always --style=numbers --line-range :100 {}"'

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
	alias lla='eza -la --git --icons=auto'
	alias tree='eza --tree --git --icons=auto'
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

# thefuck
eval "$(thefuck --alias)"

# rust
if [[ -d "$HOME/.cargo" ]]; then
  addToPath $HOME/.cargo/bin
fi

# jenv
export JENV_ROOT="${JENV_ROOT:=${HOME}/.jenv}"
if ! type jenv > /dev/null && [ -f "${JENV_ROOT}/bin/jenv" ]; then
    export PATH="${JENV_ROOT}/bin:${PATH}"
fi

if type jenv > /dev/null; then
    export PATH="${JENV_ROOT}/bin:${JENV_ROOT}/shims:${PATH}"
    function jenv() {
        unset -f jenv
        eval "$(command jenv init -)"
        jenv $@
    }
fi

# pyenv
export PYENV_ROOT="${PYENV_ROOT:=${HOME}/.pyenv}"
if ! type pyenv > /dev/null && [ -f "${PYENV_ROOT}/bin/pyenv" ]; then
    export PATH="${PYENV_ROOT}/bin:${PATH}"
fi

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

# nvm
export NVM_DIR="$HOME/.nvm"
if [ -s "$HOME/.nvm/nvm.sh" ] && [ ! "$(whence __init_nvm)" = "__init_nvm" ]; then
  declare -a __node_commands=('nvm' 'node' 'npm' 'npx' 'pnpm' 'yarn')
  function __init_nvm() {
    for i in "${__node_commands[@]}"; do unalias $i; done
    [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"  # This loads nvm
    [ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
    unset __node_commands
    unset -f __init_nvm
  }
  for i in "${__node_commands[@]}"; do alias $i='__init_nvm && '$i; done
fi

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

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}


if [[ -n "$ZSH_DEBUG" ]]; then
  zprof
fi
