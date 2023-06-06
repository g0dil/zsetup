# Start configuration added by Zim install {{{
#
# User configuration sourced by interactive shells
#

# -----------------
# Zsh configuration
# -----------------

#
# History
#

# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS

#
# Input/output
#

# Set editor default keymap to emacs (`-e`) or vi (`-v`)
bindkey -e

# Prompt for spelling correction of commands.
#setopt CORRECT

# Customize spelling correction prompt.
#SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}


# --------------------
# Module configuration
# --------------------

#
# completion
#

# Set a custom path for the completion dump file.
# If none is provided, the default ${ZDOTDIR:-${HOME}}/.zcompdump is used.
#zstyle ':zim:completion' dumpfile "${ZDOTDIR:-${HOME}}/.zcompdump-${ZSH_VERSION}"

#
# git
#

# Set a custom prefix for the generated aliases. The default prefix is 'G'.
#zstyle ':zim:git' aliases-prefix 'g'

#
# input
#

# Append `../` to your input for each `.` you type after an initial `..`
#zstyle ':zim:input' double-dot-expand yes

#
# termtitle
#

# Set a custom terminal title format using prompt expansion escape sequences.
# See http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Simple-Prompt-Escapes
# If none is provided, the default '%n@%m: %~' is used.
#zstyle ':zim:termtitle' format '%1~'

#
# zsh-autosuggestions
#

# Customize the style that the suggestions are shown with.
# See https://github.com/zsh-users/zsh-autosuggestions/blob/master/README.md#suggestion-highlight-style
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=180' # solarized-light
# ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=60' # solarized-dark

#
# zsh-syntax-highlighting
#

# Set what highlighters will be used.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Customize the main highlighter styles.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md#how-to-tweak-it
#typeset -A ZSH_HIGHLIGHT_STYLES
#ZSH_HIGHLIGHT_STYLES[comment]='fg=10'

# ------------------
# Initialize modules
# ------------------

if [[ ${ZIM_HOME}/init.zsh -ot ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  # Update static initialization script if it's outdated, before sourcing it
  source ${ZIM_HOME}/zimfw.zsh init -q
fi
source ${ZIM_HOME}/init.zsh

zstyle ':zim:prompt-pwd:fish-style' dir-length 3

# ------------------------------
# Post-init module configuration
# ------------------------------

#
# zsh-history-substring-search
#

# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Bind up and down keys
zmodload -F zsh/terminfo +p:terminfo
if [[ -n ${terminfo[kcuu1]} && -n ${terminfo[kcud1]} ]]; then
  bindkey ${terminfo[kcuu1]} history-substring-search-up
  bindkey ${terminfo[kcud1]} history-substring-search-down
fi

bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
# }}} End configuration added by Zim install

#
# User configuration sourced by interactive shells
#

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory extendedglob nomatch no_bang_hist
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/stefan/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# enable kubectl completion
if type kubectl >/dev/null; then
    source <(kubectl completion zsh)
    alias k=kubectl
    export KUBECTX_CURRENT_BGCOLOR="$(tput setab 7)"
    kctx() {
      ${ZDOTDIR}/kubectx/kubectx "$@"
      KUBE_PS1_KUBECONFIG_CACHE=""
      _kube_ps1_update_cache
    }
    kns() {
      ${ZDOTDIR}/kubectx/kubens "$@"
      KUBE_PS1_KUBECONFIG_CACHE=""
      _kube_ps1_update_cache
    }
    alias kon=kubeon
    alias koff=kubeoff
    fpath=(${ZDOTDIR}/completion $fpath)
    compinit
    source ${ZDOTDIR}/kube-ps1/kube-ps1.sh
    precmd() {
      p="$(kube_ps1)"
      if [ -n "$p" ]; then
        print -P "\n$p"
      fi
    }
    #LP_PS1_PREFIX='$(kube_ps1)'
    # The kubernetes prompt is enabled by .direnv where required
    export KUBE_PS1_ENABLED=off
fi

# enable helm completion
if type helm >/dev/null; then
    source <(helm completion zsh)
fi

# enable az (azure client) completion
if type az >/dev/null && [ -r /etc/bash_completion.d/azure-cli ]; then
    autoload -U +X bashcompinit && bashcompinit
    source /etc/bash_completion.d/azure-cli
fi

# enable oc {openshift/okd client) completion
if type oc >/dev/null; then
  source <(oc completion zsh)
fi

# zsh does not want '/' in WORDCHARS (no idea why it is in there in the first place)
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

LANG=en_US.UTF-8

case "$TERM" in
xterm*)
    export TERM=xterm-256color ;;
*)
    preexec() {
        local CMD=${1[(wr)^(*=*|sudo|-*)]}
        echo -n "\ek${SCTITLE:-$CMD}\e\\"
    }
    LP_OLD_PROMPT_COMMAND='echo -n "\ek${SCTITLE:-zsh}\e\\"'
    ;;
esac

c()
{
    local p
    local b
    local d
    local pe
    local ss
    local t
    local bd
    local sd

    p=("${(@s:/:)PWD}")
    b=("${(@M)p:#build*}")
    t="$(git rev-parse --show-toplevel 2>/dev/null)"
    if [ -z "$t" ]; then
        echo "not in git repository"
        return 1
    fi
    t=("${(@s:/:)t}")
    if [[ ${#b} -ge 1 ]]; then
        pe=${p[(i)${b[1]}]}
        (( pe = pe - 1 ))
        (( ss = pe + 2 ))
        while [[ $ss -le ${#p} ]]; do
            d=("${(@)p[1,$pe]}" "${(@)p[$ss,${#p}]}")
            dd="${(j:/:)d}"
            if [[ -d "$dd" ]]; then
                cd "$dd"
                (( a = pe + 1 ))
                (( b = ss - 1 ))
                cdb_prev_builddir=("${(@)p[$a,$b]}")
                return
            fi
            (( ss = ss + 1 ))
        done
    else
        if [ -n "$cdb_prev_builddir" ]; then
            ss=${#t}
            (( n = 1 ))
            (( ss = ss + 1 ))
            while [[ $n -le ${#cdb_prev_builddir} ]]; do
                d=("${t[@]}" "${(@)cdb_prev_builddir[1,$n]}" "${(@)p[$ss,${#p}]}")
                dd="${(j:/:)d}"
                if [[ -d "$dd" ]]; then
                    cd "$dd"
                    return
                fi
                (( n = n + 1 ))
            done
        fi
        ss=${#t}
        (( ss = ss + 1 ))
        for bd in "${(j:/:)t}/build"*(/N); do
            for sd in "${bd}"/. "${bd}/"*(/N); do
                d=("$sd" "${(@)p[$ss,${#p}]}")
                dd="${(j:/:)d}"
                if [[ -d "$dd" ]]; then
                    cd "$dd"
                    return
                fi
            done
        done
    fi
}

t()
{
    cd "$(git rev-parse --show-toplevel)"
}

tt()
{
    while true; do
        t="$(git -C .. rev-parse --show-toplevel 2>/dev/null)"
        if [ -z "$t" ]; then
            break
        fi
        cd "$t"
    done
}

ttt()
{
  if [ -n "$PROJECT_TOP" ]; then
    cd "$PROJECT_TOP";
  else
    cd
  fi
}

e()
{
    emacsclient -n "$@"
}

export PATH=/usr/lib/ccache:${HOME}/bin:${HOME}/.local/bin:${HOME}/go/bin:${HOME}/.krew/bin:${PATH}
export SCREENRC="${ZDOTDIR:-${HOME}}/.screenrc"
export EDITOR=vi
export VISUAL=vi

[ -r ${HOME}/.zhost ] && source ${HOME}/.zhost

eval "$(direnv hook zsh)"

eval `dircolors ${ZDOTDIR}/dircolors-solarized/dircolors.ansi-dark`

if [ -n "$SSH_TTY" -a -S "$SSH_AUTH_SOCK" ]; then
    case "$SSH_AUTH_SOCK" in
        $HOME/.ssh/ssh_auth_sock) ;;
        *) ln -sf $SSH_AUTH_SOCK ~/.ssh/ssh_auth_sock
    esac
fi

venv-enter() {
    bash -c "source $1/bin/activate; exec zsh"
}

alias ssh="env TERM=xterm-color ssh"
alias L="less -S"
alias P="parallel --jobs 0 --lb"
