# Home.zsh
# Settings to use when home.

ME="mickevi"
MHOME=/home/mickevi

# Default så körs medscreen..
if [[ $TERM == "screen" ]] ; then
    medscreen
else
    oscreen
fi

# Hosts ( for completion )
hosts=( xbmc dreambox )

MY_LC_LANG="en_US.utf8"
MY_LC="sv_SE.UTF-8"

# Git:
export GIT_AUTHOR_NAME="Mikael Viklund"
export GIT_AUTHOR_EMAIL="mickevi@gmail.com"
export GIT_COMMITTER_NAME="Mikael Viklund"
export GIT_COMMITTER_EMAIL="mickevi@gmail.com"
export EMAIL="mickevi@gmail.com"

export PATH=${PATH}:${HOME}/bin