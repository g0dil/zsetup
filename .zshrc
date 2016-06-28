#
# User configuration sourced by interactive shells
#

# Source zim
if [[ -s ${ZDOTDIR:-${HOME}}/.zim/init.zsh ]]; then
  source ${ZDOTDIR:-${HOME}}/.zim/init.zsh
fi

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

e()
{
    emacsclient -n "$@"
}

export PATH=/usr/lib/ccache:${HOME}/bin:${HOME}/.local/bin:${PATH}
export SCREENRC="${ZDOTDIR:-${HOME}}/.screenrc"
export EDITOR=vi
export VISUAL=vi

[ -r ${HOME}/.zhost ] && source ${HOME}/.zhost

eval `dircolors ${ZDOTDIR}/dircolors-solarized/dircolors.ansi-dark`

alias !=screen
