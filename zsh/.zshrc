#!/bin/zsh

export HISTFILE=~/.zsh_history.66085217
export HISTSIZE=50000
export SAVEHIST=50000
export XAUTHORITY=~/.Xauthority

# fixa inkonsekvens mellan solaris/linux
if [[ "${HOSTNAME}x" == "x" ]] ; then
    HOSTNAME=$HOST
    
fi
# översätt hostname till vip 
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
    
# ifall zsh kors utan screen. 
oscreen() {
    precmd () { print -Pn "\e]0;[%n@%M]%# [%~]\a" }
    preexec () { print -Pn "\e]0;[%n@%M]%# [%~] ($1)\a" }

}

medscreen() {
#    unset DISPLAY

    preexec () {
	local CMD=`echo $1 | cut -d " " -f1`
#	local host=${HOSTNAME#sadb}
	echo -ne "\ek${USER//66085217/jag}@$host:$CMD\e\\"
    }
    precmd() {
#	local host=${HOSTNAME#sadb}
	echo -ne "\ek${USER//66085217/jag}@$host\e\\"
    }
}

# Default så körs medscreen..
medscreen

# ändra termen till xterm om det körs via cygwin.
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
    emulate -L sh
    source "$@"
  }

if [[ -f $HOME/.alias ]] ; then
        sh_source $HOME/.alias
fi
if [[ $USER = wdp[0-9][0-9][0-9]* || $USER = fkappl ]] ; then
        sh_source ~/.profile
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
export ALTERNATE_EDITOR=emacs EDITOR=emacsclient


# generlla aliases 
alias jentityread="java -jar $MHOME/java/entityRead.jar"
alias psj="ps -fu $USER | grep java | grep -v grep"


export SVN_REPO=file://${MHOME}/repository
export KENT="/nfshome/66086838/"
export UBE="/nfshome/66101029/"
export GEORG="/nfshome/40042817/"
export MICKE="/nfshome/66085217/"

## OS specific
# Linux
if [[ $(uname) == "Linux" ]] ; then
        echo "Using Linux settings"
        export PATH=/${MHOME}/local-linux/bin:~/bin:$usr/bin/:${PATH}:${MHOME}/bin:/program/tp/wlstools
        export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:$MHOME/local-linux/lib
        alias ls="ls --color=tty -F"
	alias emacs="/usr/bin/emacs --load /nfshome/66085217/.emacs"
	alias vi="vim -u  /nfshome/66085217/.vimrc"
	alias vim="vim -u  /nfshome/66085217/.vimrc"
	alias grep="grep --color"
	alias egrep="egrep --color"
	ediff-emacs() {
	    /usr/bin/emacs --load /nfshome/66085217/.emacs -geometry 150x65+10+10 -eval "(ediff-files \"$1\" \"$2\")"
	}
	
	MY_LC_LANG="en_US.iso885915"
	MY_LC="sv_SE.iso885915"

else
# Solaris
        echo "Using Solaris Settings"
	if [[ $TERM == "screen" ]] ; then
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

export PATH=/usr/local/bin:$PATH:/opt/VRTS/bin/
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




_ssh() {
    local SSHOPTS="-X -o StrictHostKeyChecking=no -t"
    local SHELLOPTS="export ZDOTDIR=/nfshome/66085217/zsh/ && HISTFILE=.zshhist.66085217 zsh -i"
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
