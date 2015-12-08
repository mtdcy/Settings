[ -z "$PS1" ] && return

# shell completion #{{{
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi
# fast shellcompletion
#set show-all-if-ambiguous on
#}}}

# default font dir, currently only used by gnuplot
#export GDFONTPATH=/home/peter/.fonts

# for OOO

# Prompt #{{{ 
unset PS1 PS2 PS3 PS4 
#PS1='\e[33;44m\h \e[30;42m\w\e[0;0m \n\e[35;46m\u \e[30;41m>>>\e[0;0m '
#PS1='\[\033[37;44m\]\u@\h\[\033[30;42m\] \w \[\033[30;41m\]>>>\[\033[0m\] '
#PS1='[\u@\h \w]\$ '
PS1='\[\e[1;32m\][\u@\h \w]\$\[\e[0m\] ' ###green one
#PS1='[\u@\h]\$ '
PS2='+> '
PS3='+++> '
PS4='+++++> '
#PROMPT_COMMAND='RET=$?; if [[ $RET=0 ]]; then echo -ne "\033[4;32m$RET\033[0m"; else echo -ne "\033[4;31m$RET\033[0m"; fi; echo -n " "'  
#case ${TERM} in
#	xterm*|rxvt*|Eterm|aterm|kterm|gnome*|interix)
#		PROMPT_COMMAND='RET=$?; if [[ $RET = 0 ]]; then echo -ne "\033[30;42m$RET\033[0m"; else echo -ne "\033[30;41m$RET\033[0m"; fi;echo -ne "\033]0;${PWD/$HOME/~}\007"'
#		;;
#	screen)
#		PROMPT_COMMAND='RET=$?; if [[ $RET = 0 ]]; then echo -ne "\033[30;42m$RET\033[0m"; else echo -ne "\033[30;41m$RET\033[0m"; fi;echo -ne "\033_${PWD/$HOME/~}\033\\"'
#		;;
#esac
#}}}

# some alias 

# General# {{{
#eval "`dircolors -b`"
#alias ls='ls --color=auto'
alias ll='ls -lh'
alias la='ls -A'
alias lla='ls -la'
#alias l='ls -CF'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
#alias grep='grep --color=auto'
#alias fgrep='fgrep --color=auto'
#alias egrep='egrep --color=auto'
alias du='du -h --max-depth=1'
alias diff='diff -aur'
alias mplayer='mplayer -shuffle'
alias download='aria2c -j5 -s 5 -m 5' 

alias rm='rm -i'
# }}}

# archlinux pacman # {{{
#alias pSs='pacman -Ss'
#alias pQs='pacman -Qs'
#alias pQl='pacman -Ql'
#alias pRn='sudo pacman -Rn'
#alias pS='sudo pacman -S'
#alias pSyy='sudo pacman -Syy'
#alias pSu='sudo pacman -Su'
#
#alias y='yaourt'
#alias yS='yaourt -S'
#alias ySa='yaourt -S -aur'
#alias ySs='yaourt -Ss'
#alias ySb='yaourt -Sb' # compile from source, abs
#alias ySl='yaourt -Sl'
#
#alias ySyy='yaourt -Syy'
#alias ySu='yaourt -Syu'
#alias ySua='yaourt -Syu -aur'
#alias ySbua='yaourt -Sbu -aur'
#
#alias yRcs='yaourt -Rcs'
#alias yRncs='yaourt -Rncs'
#
#alias yQs='yaourt -Qs'
#alias yQo='yaourt -Qo'
#alias yQl='yaourt -Ql'
# }}}

# screen # {{{
#alias email='screen -t email mutt'
#alias irc='screen -t irc irssi'
#alias news='screen -t news newsbeuter'
#alias music='screen -t music ncmpc'
#alias log='screen -t log sudo cat /var/log/everything.log | tail'
#alias s='screen'
## }}}

# extract#{{{
extract () {
    if [ -f $1 ]
    then
	    case $1 in
		    *.tar.bz2)  tar xvjf $* 	;;
    		*.tar.gz) 	tar xvzf $* 	;;
            *.tar.xz)   tar xvfJ $*     ;;
	    	*.bz2) 		bunzip2 $* 	;;
    		*.rar) 		unrar x $* 	;;
	    	*.gz) 		gunzip $* 	;;
		    *.tar) 		tar xvf $* 	;;
    		*.tbz2) 	tar xvjf $* 	;;
	    	*.tgz) 		tar xvzf $* 	;;
		    *.zip) 		unzip $* 	;;
    		*.Z) 		uncompress $* 	;;
	    	*.7z) 		7z x $* 	;;
		    *) 	echo "Error: don't knwon how to extract '$1' ..." ;;
	    esac
    else
	    echo "'$1' doesn't exist ..."
    fi
}
#}}}

# colorize the man-pages#{{{
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'                           
export LESS_TERMCAP_so=$'\E[01;44;33m'                                 
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'
#}}}


#export XMODIFIERS=@im=fcitx
#export GTK_IM_MODULE=xim
#export QT_IM_MODULE=xim
#

export GDK_NATIVE_WINDOWS=1

export SVN_MERGE=meld

#export GREP_OPTIONS='-R --exclude-dir=.svn --exclude-dir=.git --exclude=*~ --binary-files=without-match --color=auto -H -n'

export HISTSIZE=5000
export HISTTIMEFORMAT='%F %T '
export HISTCONTROL=erasedups:ignorespace

export EDITOR=vim

# for mac, make ls output colors
export CLICOLOR=1
LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:';
export LS_COLORS

##
# Your previous /Users/Chen/.bash_profile file was backed up as /Users/Chen/.bash_profile.macports-saved_2015-03-23_at_17:58:04
##

# autojump for bash 
if [ -f /opt/local/etc/profile.d/autojump.bash ]; then
    . /opt/local/etc/profile.d/autojump.bash
fi

# MacPorts Installer addition on 2015-03-23_at_17:58:04: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

# Can't set this when building Android
#export PATH="/opt/local/libexec/gnubin:$PATH"

# set the number of open files to be 1024
ulimit -S -n 1024

export NDK=/work/android-ndk-r10e
export SDK=/work/android-sdk-macosx

export PATH=/work/bin:$NDK:$SDK/platform-tools:$SDK/tools:$PATH

#export JAVA_HOME=/work/jdk1.6.0_45
#export PATH=$JAVA_HOME/bin:$PATH 
#export CLASSPATH=$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar 

alias remote='ssh chenfang@192.168.2.88'

