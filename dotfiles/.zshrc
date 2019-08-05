# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

export PATH="/usr/local/bin:$PATH"
export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
export PATH="$(brew --prefix gnu-sed)/libexec/gnubin:$PATH"
export PATH=$HOME/bin:$NDK:$SDK/platform-tools:$SDK/tools:$PATH

[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="arrow"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git svn adb autojump extract)

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
export LC_ALL=en_US.UTF-8  
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='mvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# set the number of open files to be 1024
ulimit -S -n 1024

export NDK=/$HOME/android/android-ndk-r13b
export SDK=/$HOME/android/android-sdk-macosx

#export JAVA_HOME=/work/jdk1.6.0_45
#export PATH=$JAVA_HOME/bin:$PATH 
#export CLASSPATH=$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar 

alias remote='ssh chenfang@192.168.2.88'

#eval "`dircolors -b`"
alias ls='ls --color=auto'
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
#alias vim='mvim -v'

export GOPATH=/$HOME/go
export PATH="/usr/local/go/bin:$PATH"
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
