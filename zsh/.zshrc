# _________________________________
#< Life is like a box of chocolate >
# ---------------------------------
#        \   ^__^
#         \  (oo)\_______
#            (__)\       )\/\
#                ||----w |
#                ||     ||

# benchmark zsh
alias zsh-time="time zsh -i -c exit"
alias zsh-debug="time ZSH_DEBUG=1 zsh -i -c exit"
if [[ -n "$ZSH_DEBUG" ]]; then
  zmodload zsh/zprof
fi

[[ -d $ZSH_CACHE_DIR ]] || mkdir -p $ZSH_CACHE_DIR

export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export EDITOR="vim"
export VISUAL=$EDITOR
export PAGER="less -F -X"
export COLORTERM="truecolor"

# history
export HISTFILE=$ZSH_CACHE_DIR/.zsh_history
export HISTSIZE=50000
export SAVEHIST=$HISTSIZE
export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)"
setopt hist_find_no_dups
setopt hist_ignore_space
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

addToPath $HOME/bin

# homebrew
[[ -x /opt/homebrew/bin/brew ]] && eval $(/opt/homebrew/bin/brew shellenv)
[[ -x /usr/local/bin/brew ]] && eval $(/usr/local/bin/brew shellenv)

# completion
setopt prompt_subst
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$ZSH_CACHE_DIR/.zcompcache"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu select
zstyle ':completion:*' list-suffixes
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# Load known hosts file for auto-completion with ssh and scp commands
if [ -f ~/.ssh/known_hosts ]; then
  zstyle ':completion:*' hosts $( sed 's/[, ].*$//' $HOME/.ssh/known_hosts )
  zstyle ':completion:*:*:(ssh|scp):*:*' hosts `sed 's/^\([^ ,]*\).*$/\1/' ~/.ssh/known_hosts`
fi

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
fi

autoload bashcompinit && bashcompinit
autoload -Uz compinit
if [[ -n "$ZSH_COMPDUMP"(#qN.mh+24) ]]; then
	compinit -d "$ZSH_COMPDUMP"
else
	compinit -C
fi

if type docker &>/dev/null; then
  source <(docker completion zsh)
fi

if type kubectl &>/dev/null; then
  source <(kubectl completion zsh)
fi

# starship
eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# ripgrep
export RIPGREP_CONFIG_PATH="~/.config/ripgrep/ripgreprc"

# fzf
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
export FZF_DEFAULT_OPTS='
  --color=query:regular
  --color=bg+:#313244,spinner:#f5e0dc,hl:#f38ba8,border:#45475a
  --color=fg:#cdd6f4,header:#89b4fa,info:#cba6f7,pointer:#89b4fa
  --color=marker:#fab387,fg+:#f9e2af,prompt:#cba6f7,hl+:bold:#f38ba8
  --color=gutter:-1
  --height 100%
  --border=rounded
  --multi'
export FZF_CTRL_T_OPTS='--preview "bat --color=always --style=numbers --line-range :100 {}"'
export FZF_CTRL_R_OPTS=' 
  --reverse
  --preview "echo {}" 
  --bind "ctrl-/:toggle-preview" 
  --bind "ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort" 
  --header "ctrl+y: copy command into clipboard, ctrl+/: toggle preview"  
  --preview-window bottom:3:hidden:wrap'

# zoxide
eval "$(zoxide init zsh)"

# alias
alias ls="ls -G"
alias ll="ls -alh"
alias lll="ls -alhTOe@"
alias rm="rm -i"
alias mv="mv -i"
alias cp="cp -i"

if type eza &>/dev/null; then
	alias ll="eza -l --git --icons=auto"
	alias lla="eza -la --git --icons=auto"
	alias tree="eza --tree --git --icons=auto"
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
if type thefuck &> /dev/null; then
  eval "$(thefuck --alias)"
fi

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
function nvm() {
  echo "NVM not loaded! Loading now..."
  unset -f nvm
  export NVM_PREFIX=$(brew --prefix nvm)
  [ -s "$NVM_PREFIX/nvm.sh" ] && \. "$NVM_PREFIX/nvm.sh"  # This loads nvm
  [ -s "$NVM_PREFIX/etc/bash_completion.d/nvm" ] && \. "$NVM_PREFIX/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
  nvm "$@"
}

# yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# fzf
function fzf-process-selection() {
  local current_buffer=$BUFFER
  local pids=$(ps -A -opid,command | fzf --multi --reverse --header-lines=1 \
    --prompt="process > " \
    --bind "ctrl-/:toggle-preview" \
    --preview="ps -o 'pid,ppid=PARENT,user,%cpu,rss=RSS_IN_KB,start=START_TIME,command' -p {1} || echo 'Cannot preview {1} because it exited.'" \
    --preview-window="bottom:3:hidden:wrap" | awk '{print $1}' | tr '\n' ' ')
  BUFFER="${current_buffer}${pids}"
  CURSOR=$#BUFFER
}

zle -N fzf-process-selection
bindkey '^p' fzf-process-selection

function fzf-git-log() {
  git log --graph --color=always --date=short \
    --format="%C(auto)%h%C(auto)%d %s %C(blue)%cd %C(black)%C(bold)<%an>" "$@" | \
  fzf --prompt="git log > " --ansi --no-sort --reverse --tiebreak=index \
    --bind=ctrl-f:page-down,ctrl-b:page-up \
    --bind=ctrl-s:toggle-sort \
    --bind "ctrl-m:execute:
            (grep -o '[a-f0-9]\{7\}' | head -1 |
            xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
            {}
FZF-EOF"
}

zle -N fzf-git-log
bindkey '^g' fzf-git-log

function _fzf-git-branch() {
  git rev-parse HEAD > /dev/null 2>&1 || return
  git branch --color=always --all --sort=-committerdate |
    grep -v HEAD |
    fzf --prompt="git branch > " --ansi --no-multi \
      --preview-window right:65% \
      --preview 'git log -n 50 --color=always --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed "s/.* //" <<< {})' |
    sed "s/.* //"
}

function fzf-git-checkout() {
  git rev-parse HEAD > /dev/null 2>&1 || return
  local branch
  branch=$(_fzf-git-branch)
  if [[ "$branch" = "" ]]; then
    echo "No branch selected."
    return
  fi
  # If branch name starts with 'remotes/' then it is a remote branch. By
  # using --track and a remote branch name, it is the same as:
  # git checkout -b branchname --track origin/branchname
  if [[ "$branch" = 'remotes/'* ]]; then
    git checkout --track $branch
  else
    git checkout $branch;
  fi
}

zle -N fzf-git-checkout
bindkey "^b" fzf-git-checkout

function fzf-keybind() {
  zle $(bindkey | fzf --prompt="keybind > " | cut -d " " -f 2)
}

zle -N fzf-keybind
bindkey '^xk' fzf-keybind

function fzf-alias() {
  BUFFER=$(alias | fzf --query "$LBUFFER" --prompt="alias > " | awk -F"=" '{print $1}')
  print -z "$BUFFER"
}

zle -N fzf-alias
bindkey '^xa' fzf-alias

function fzf-weather() {
  curl wttr.in/$(echo -e "Hangzhou\nShanghai" | fzf --prompt="Weather > ") | less -R
}

# .gitignore
function gi() {
  echo "Fetch language list from www.gitignore.io..."
  local languages=$(curl -sL https://www.gitignore.io/api/list)
  local selected_langs=$(echo $languages | sed -e 's/,/\n/g' | \
    fzf -i --no-sort --reverse --multi --prompt=".gitignore > ")
  local query_param="${selected_langs//$'\n'/,}"

  if [ -n "$query_param" ]; then
    echo "Generate a .gitignore file for $query_param..."
    curl -L -s https://www.gitignore.io/api/$query_param >> .gitignore
    echo "Done!"
  fi
}

function fzf-dev {
  local workspace_dir="$HOME/workspace"
  local directories=($(echo "$HOME/dotfiles"
    if [ -d "${workspace_dir}/projects" ]; then
      fd --hidden --prune --type d -d 4 -a --exclude={node_modules,build,target,dist} \
        '^\.git$' "${workspace_dir}/projects" | sed 's/\/\.git\///' 
    fi

    if type ghq > /dev/null && [ -d "$(ghq root)" ]; then
      ghq list --full-path
    fi

    if [ -d "${workspace_dir}/sources" ]; then
      fd --hidden --prune --type d -d 4 -a --exclude={node_modules,build,target,dist} \
        '^\.git$' "${workspace_dir}/sources" | sed 's/\/\.git\///' 
    fi
  ))

  if [ ${#directories[@]} -eq 0 ]; then
    echo "No directories found!"
    return
  fi

  local moveto=$(printf "%s\n" "${directories[@]}" | fzf +m \
    --preview="ls -AF1 --color=always {}" \
    --prompt="workspace > " \
    --preview-window=right:30%:hidden:wrap \
    --bind="ctrl-/:toggle-preview" \
    --header="ctrl+/: toggle preview" \
    --height=100% \
    --border \
    --exit-0)

  if [ "$moveto" ]; then
    cd $moveto
    # rename session if in tmux
    if [[ ! -z ${TMUX} ]]; then
      repo_name=${moveto##*/}
      tmux rename-session ${repo_name//./-}
    fi
  fi

  zle reset-prompt
}

zle -N fzf-dev
bindkey '^o' fzf-dev

# Print the 256 color palette
# Online version available at:
# https://jonasjacek.github.io/colors/
palette() {
    local -a colors
    for i in {000..255}; do
        colors+=("%F{$i}$i%f")
    done
    print -cP $colors
}

# Print the zsh color code for a 256 color number.
# This command is useful because it yields the
# color code used with Fzf-Tab and with LS_COLORS.
printcolor() {
    local color="%F{$1}"
    echo -E ${(qqqq)${(%)color}}
}

# end
if [[ -n "$ZSH_DEBUG" ]]; then
  zprof
fi
