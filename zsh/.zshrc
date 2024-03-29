#!/bin/zsh
#zmodload zsh/regex

export HISTFILE=~/.zsh_history.66085217
export HISTSIZE=50000
export SAVEHIST=50000
#export XAUTHORITY=~/.Xauthority


# fixa inkonsekvens mellan solaris/linux
if [[ "${HOSTNAME}x" == "x" ]] ; then
    HOSTNAME=$HOST
fi

if [[ $HOSTNAME = sadbprodwlsmgmt* ]] ; then
    export DISPLAY=localhost:129.0
    export PATH=$PATH:/domains/mysql/mysql/bin
fi

# �vers�tt hostname till vip
if [[ ! -z $SSH_CONNECTION ]] ; then
	local host=${SSH_CONNECTION%\ *}
	host=${host##*\ }
	host=$(host $host)
	host=${host##*\ }
	host=${host%%\.*}
	host=${host#sadb}
	host=${host#vsg}
	host=${host//localhost/lh}
else
    local host=${HOSTNAME#sadb}
    host=${host#vsg}
    host=${host//localhost/lh}
fi
host=${host//prodwlsmgmt/mgmt}

# ifall zsh kors utan screen.
oscreen() {
    echo "Disabling screen"
    precmd () { print -Pn "\e]0;[%n@%M]%# [%~]\a" }
    preexec () { print -Pn "\e]0;[%n@%M]%# [%~] ($1)\a" }
}

stuipd() {
    echo "Stupid mode"
    precmd() {}
    preexec () {}
}

medscreen() {
    echo "Enabling screen..."
    preexec () {
	local CMD=`echo $1 | cut -d " " -f1`
	echo -ne "\ek${USER//66085217/jag}@$host:$CMD\e\\"
    }
    precmd() {
	echo -ne "\ek${USER//66085217/jag}@$host\e\\"
    }
}

if [[ $TERM == "screen" ]] ; then
    medscreen
elif [[ $TERM == "dumb" ]] ; then
    stuipd
else
    oscreen
fi

# �ndra termen till xterm om det k�rs via cygwin.
if [[ $TERM == "cygwin"  || $TERM == "vt100" ]] ; then
    print "Changing term from $TERM to xterm"
    export TERM="xterm"
fi


# Hosts ( for completion )
hosts=( sadbprodlogin1 sadbsatlogin1 sadbprodwls1 sadbsatwls1 sadburawls sadbsatapp7 sadbverifapp9 sadburaapp5 sadbteknikopa5 sadbprodwlsmgmt1 )

# Set/unset  shell options

bindkey -e                 # emacs key bindings
bindkey ' ' magic-space    # also do history expansion on space


autoload -U compinit compinit
setopt autopushd pushdminus pushdsilent pushdtohome
setopt autocd
setopt cdablevars
setopt ignoreeof
setopt interactivecomments
setopt nobanghist
setopt noclobber
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt SH_WORD_SPLIT
setopt nohup

##################################################################
# Stuff to make my life easier

# allow approximate
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# tab completion for PID :D
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

# cd not select parent dir
zstyle ':completion:*:cd:*' ignore-parents parent pwd

# useful for path editing  backward-delete-word, but with / as additional delimiter
backward-delete-to-slash () {
  local WORDCHARS=${WORDCHARS//\//}
  zle .backward-delete-word
}
zle -N backward-delete-to-slash

##################################################################
# Key bindings
# http://mundy.yazzy.org/unix/zsh.php
# http://www.zsh.org/mla/users/2000/msg00727.html

typeset -g -A key
bindkey '^?' backward-delete-char
bindkey '^[[1~' beginning-of-line
bindkey '^[[5~' up-line-or-history
bindkey '^[[3~' delete-char
bindkey '^[[4~' end-of-line
bindkey '^[[6~' down-line-or-history
bindkey '^[[A' up-line-or-search
bindkey '^[[D' backward-char
bindkey '^[[B' down-line-or-search
bindkey '^[[C' forward-char
# Detta funkar inte...
bindkey '^[w' backward-delete-to-slash
# completion in the middle of a line
bindkey '^i' expand-or-complete-prefix


# fkappl/wdp
sh_source() {
    emulate -L ksh
    source "$@"
  }

if [[ -f $HOME/.alias ]] ; then
        sh_source $HOME/.alias
fi
if [[ $USER = [wt]dp[0-9][0-9][0-9]* || $USER = fkappl ]] ; then
    print "Reading ~/.profile"
    if [[ -f $HOME/.profile ]] ; then
        sh_source $HOME/.profile
    else
	print "No profile..."
    fi
fi

setprompt () {
	# load some modules
	autoload -U colors zsh/terminfo # Used in the colour alias below
	colors
	setopt prompt_subst

       PROMPT="#[%n@%m]-[%D{%a %y-%m-%d} %*]-[%(?.%{$fg_bold[white]%}.%{$fg_bold[red]%})%?%{$reset_color%}]
#%3c%# "
}

setprompt

## Defines

MHOME=/nfshome/66085217
#export EDITOR="emacs"
#export ALTERNATE_EDITOR=emacs EDITOR=emacsclient
export ALTERNATE_EDITOR="" EDITOR=emacsclient #Empty alternate editor to start the daemon if not running


# generlla aliases
alias jentityread="java -jar $MHOME/java/entityRead.jar"
alias psj="ps -fu $USER | grep java | grep -v grep"


export SVN_REPO=file://${MHOME}/repository
export KENT="/nfshome/66086838/"
export UBE="/nfshome/66101029/"
export GEORG="/nfshome/40042817/"
export MICKE="/nfshome/66085217/"

# Clearcase crap
if [ -d /opt/rational/clearcase/bin ] ; then
    PATH=$PATH:/opt/rational/clearcase/bin
fi

## OS specific
# Linux
if [[ $(uname) == "Linux" ]] ; then
        echo "Using Linux settings"
        PATH=/${MHOME}/local-linux/bin:~/bin:$usr/bin/:${PATH}:${MHOME}/bin:/program/tp/wlstools
	if [[ -d "/produkter/oracle/java/bin" ]] ; then
	    PATH="/produkter/oracle/java/bin:$PATH"
	elif [[ -d "/produkter/bea/jdk/bin" ]] ; then
	    PATH=/produkter/bea/jdk/bin:$PATH
	elif [[ -d "/produkter/bea/jdk_version/bin" ]] ; then
	    PATH=/produkter/bea/jdk_version/bin:$PATH
	fi
	if [[ -d "/produkter/gnu/jython/bin" ]] ; then
	    PATH="/produkter/gnu/jython/bin:$PATH"
	fi
        if [[ -d "/produkter/gnu/python/bin" ]] ; then
            PATH="/produkter/gnu/python/bin:${PATH}"
        fi

	export PATH
        export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:$MHOME/local-linux/lib
	if [[ -d /produkter/gnu/python/lib ]] ; then
	    export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/produkter/gnu/python/lib
	fi
        export PYTHONPATH="/nfshome/66085217/python-lib"
        alias ls="ls --color=tty -F"
	alias emacs="emacs --load /nfshome/66085217/.emacs"
	alias vi="vim -u  /nfshome/66085217/.vimrc"
	alias vim="vim -u  /nfshome/66085217/.vimrc"
	alias vimdiff="vimdiff -u  /nfshome/66085217/.vimrc"
	alias grep="grep --color"
	alias egrep="egrep --color"
	# Make less not clear screen on exit, and not exit at EOF
	alias less="less -Xe"
	# Make man behave.
	export PAGER="less -Xe"
	ediff-emacs() {
	    /usr/bin/emacs --load /nfshome/66085217/.emacs -geometry 150x65+10+10 -eval "(ediff-files \"$1\" \"$2\")"
	}

	MY_LC_LANG="en_US.iso885915"
	MY_LC="sv_SE.iso885915"



else
# Solaris
        echo "Using Solaris Settings"
	if [[ $TERM == "screen" ]] ; then
            echo "Changing term to xterm"
	    export TERM=xterm
	fi
        export PATH=${PATH}:${MHOME}/local/bin:~/bin:${MHOME}/bin:/usr/openwin/bin
        export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:$MHOME/local/lib
	alias ls="ls -F"
	alias emacs="/nfshome/40042817/bin/emacs --load /nfshome/66085217/.emacs"
	MY_LC_LANG="en_US.ISO8859-15"
	MY_LC="sv_SE.ISO8859-15@euro"

	#alias ediff-emacs="/nfshome/66085217/bin/ediff-emacs"

fi

export PATH=$PATH:/opt/VRTS/bin/:/usr/local/bin
unset LC_ALL
export LANG=$MY_LC_LANG
export LC_CTYPE=$MY_LC_LANG
export LC_NUMERIC=$MY_LC
export LC_TIME=$MY_LC
export LC_COLLATE=$MY_LC
export LC_MONETARY=$MY_LC
export LC_MESSAGES=$MY_LC_LANG
export LC_PAPER=$MY_LC
export LC_NAME=$MY_LC
export LC_ADDRESS=$MY_LC
export LC_TELEPHONE=$MY_LC
export LC_MEASUREMENT=$MY_LC
export LC_IDENTIFICATION=$MY_LC

# Git:
export GIT_AUTHOR_NAME="Mikael Viklund"
export GIT_AUTHOR_EMAIL="mikael.viklund@forsakringskassan.se"
export GIT_COMMITTER_NAME="Mikael Viklund"
export GIT_COMMITTER_EMAIL="mikael.viklund@forsakringskassan.se"
export EMAIL="mikael.viklund@forsakringskassan.se"


wdp() {
    if [ -z "$2" ] ; then
        local w=$1
        local h=$(hostname | cut -c 5-)
    else
        local w=$2
        local h=$1
    fi

    case $h in
        prod*) VSG="p" ;;
        sat*) VSG="a" ;;
        ura*) VSG="k" ;;
        verif*) VSG="v" ;;
        plu*) VSG="z";;
        *) echo "Felaktig miljo $h"
        return;
        ;;
        esac

    case $w in
        [0-9][0-9][0-9]);;
        *)
            echo "felaktig dom�n $w"
            return;;
    esac


    _ssh wdp${w}@vsg${VSG}wdp${w}

}


# start emacsdaemon if on wlsmgmt3, and not already running.
# if [[ $HOSTNAME = sadbprodwlsmgmt3 ]] ; then
#     A=$(ps -fu $USER | grep emacs | grep daemon)
#     local res=$?
#     if (( res )) ; then
#         echo "Starting emacs daemon"
#         $(emacs --daemon)
#     fi
# fi

tdp() {
    if [ -z "$2" ] ; then
        local w=$1
        local h=$(hostname | cut -c 5-)
    else
        local w=$2
        local h=$1
    fi

    case $h in
        prod*) VSG="p" ;;
        sat*) VSG="a" ;;
        ura*) VSG="k" ;;
        verif*) VSG="v" ;;
        plu*) VSG="z";;
        *) echo "Felaktig miljo $h"
        return;
        ;;
        esac

    case $w in
        [0-9][0-9][0-9]);;
        *)
            echo "felaktig dom�n $w"
            return;;
    esac


    _ssh tdp${w}@vsg${VSG}tdp${w}

}



_ssh() {
    local SSHOPTS="-Y -o StrictHostKeyChecking=no -t"
    local SHELLOPTS="export ZDOTDIR=/nfshome/66085217/zsh/ && HISTFILE=~/.zshhist.66085217 zsh -i"
    local KEY
    if [[ "$@" == *prod* || "$@" == *vsgp?dp[0-4]* ]] ; then
	KEY="fkapplprod_dsa"
    elif [[ "$@" == *verif* || "$@" == *vsgv?dp[0-4]* ]] ; then
	KEY="fkapplverif_dsa"
    elif [[ "$@" == *verif* || "$@" == *vsgv?dp[0-4]* ]] ; then
	KEY="fkapplverif_dsa"
    elif [[ "$@" == *ura* || "$@" == *vsgk?dp[0-4]* ]] ; then
	KEY="fkapplura_dsa"
    elif [[ "$@" == *sat* || "$@" == *vsga?dp[0-4]* ]] ; then
	KEY="fkapplsat_dsa"
    elif [[ "$@" == *plu* || "$@" == *vsgz?dp[0-4]* ]] ; then
	KEY="fkapplplu_dsa"
    elif [[ "$@" == *wlsmgmt* || "$@" == *wdp5* ]] ; then
	KEY="fkapplwlsmgmt_dsa"
    fi

    if [[ -z $KEY ]] ; then
	ssh $SSHOPTS $@ $SHELLOPTS
    else
	echo "KEY=$KEY"
	ssh $SSHOPTS -i $MICKE/.ssh/$KEY $@ $SHELLOPTS
    fi

}
