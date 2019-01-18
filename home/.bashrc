# environment variables
    # Locally built binaries when unable to sudo
    export PATH=$PATH:$HOME/bin/
    export PATH=$PATH:$HOME/scripts/
    export TESTSSL_INSTALL_DIR="$HOME/scripts"
    # Install Ruby Gems to ~/gems
    export GEM_HOME=$HOME/gems
    export PATH=$HOME/gems/bin:$PATH
	export PATH=$HOME/go/bin:$PATH

# WSL specfic exports 
if grep -qE "(Microsoft|WSL)" /proc/version &> /dev/null ; then
    echo "Windows 10 Bash Detected"
    export DISPLAY=:0
fi

# enable bash completion in interactive shells
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# colors
 export TERM=xterm-256color
 export LS_OPTIONS='--color=auto'
 eval "`dircolors -b`"
 alias ls='ls $LS_OPTIONS'

 #colored man pages

export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;37m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# custom shortcuts
 alias sta='sudo tmux attach'	# reattach to root tmux using user dotfiles
 alias irc='tmux attach -t irc'	# reattach to weechat running in session 'irc'
 alias ?='history | more'	# displays history
 alias c='clear'                                                         
 alias screen='screen -s /bin/bash'	# exec bash on screen
 alias ..='cd ..'
 alias updateapt='apt update && apt upgrade'
 alias cleanapt='apt autoclean && apt autoremove'
 alias tb="nc dump.spicypixel.co.uk 9999"
 alias eirc='autossh htpc -t tmux attach'
#Custom Functions

function freemem(){
    awk '/MemFree/{print $2}' /proc/meminfo
}

function freespaceroot(){
    df -kh . | awk 'END {print $4}'
}

function localips(){
	ifconfig | grep "inet addr" | awk '{print $2}' | awk -F: '{print $2}'
}

function connectedips(){
    netstat -lantp | grep ESTABLISHED |awk '{print $5}' | awk -F: '{print $1}' | sort -u
}

function mirrorsite() {
	wget --mirror -p --convert-links -P ./ $1
}

function plexscan() {
    if [ -z "$1" ]
		then curl -d "eventType=Manual&filepath=$PWD" "http://localhost:3467/4e210bd0216d4906afda744a29a52a24"
	else
		curl -d "eventType=Manual&filepath=$1" "http://localhost:3467/4e210bd0216d4906afda744a29a52a24"
	fi
}

function url2cloud() {
    TMPFILE=$(mktemp); TMPDIR=$(mktemp -d); CLOUDPATH="$1"; GRABURL="$2"; DESTNAME="$3"
    if [ -z "$DESTNAME" ]  
        then DESTNAME=$(basename $2)
    fi
    if [ ! -d "$CLOUDPATH" ]   
        then printf "\nDestination directory doesn't exist"
        return
    fi
    printf "\nDownloading $GRABURL to $TMPFILE\n"; wget "$GRABURL" -O "$TMPFILE" -q --show-progress
    FILETYPE=$(file --mime-type -b "$TMPFILE")
    printf "\nMime-type detected: $FILETYPE"
    case $FILETYPE in
        application/zip)
            printf "\nUnzipping source file: "; unzip -d $TMPDIR $TMPFILE
            printf "\nMoving unzipped files: "; mv -v "$TMPDIR"/* "$CLOUDPATH"
            printf "\nTemporary file "; #rm -v "$TMPFILE"
            ;;
        *)
            printf "\nMoving downloaded file: "; mv -v "$TMPFILE" "$CLOUDPATH"/"$DESTNAME"
    esac
}
	
# import homeshick
source "$HOME/.homesick/repos/homeshick/homeshick.sh"
source "$HOME/.homesick/repos/homeshick/completions/homeshick-completion.bash"

# Sensible Bash - An attempt at saner Bash defaults
# Maintainer: mrzool <http://mrzool.cc>
# Repository: https://github.com/mrzool/bash-sensible
# Version: 0.2.2

# Unique Bash version check
if ((BASH_VERSINFO[0] < 4))
then 
  echo "sensible.bash: Looks like you're running an older version of Bash." 
  echo "sensible.bash: You need at least bash-4.0 or some options will not work correctly." 
  echo "sensible.bash: Keep your software up-to-date!"
fi


if [ -t 1 ]
then
    ## GENERAL OPTIONS ##

    # Prevent file overwrite on stdout redirection
    # Use `>|` to force redirection to an existing file
    set -o noclobber

    # Update window size after every command
    shopt -s checkwinsize

    # Automatically trim long paths in the prompt (requires Bash 4.x)
    PROMPT_DIRTRIM=2

    # Enable history expansion with space
    # E.g. typing !!<space> will replace the !! with your last command
    bind Space:magic-space

    # Turn on recursive globbing (enables ** to recurse all directories)
    shopt -s globstar 2> /dev/null

    # Case-insensitive globbing (used in pathname expansion)
    shopt -s nocaseglob;

    ## SMARTER TAB-COMPLETION (Readline bindings) ##

    # Perform file completion in a case insensitive fashion
    bind "set completion-ignore-case on"

    # Treat hyphens and underscores as equivalent
    bind "set completion-map-case on"

    # Display matches for ambiguous patterns at first tab press
    bind "set show-all-if-ambiguous on"

    # Immediately add a trailing slash when autocompleting symlinks to directories
    bind "set mark-symlinked-directories on"

    # Cycle through tab suggestions
    bind TAB:menu-complete

    ## SANE HISTORY DEFAULTS ##

    # Append to the history file, don't overwrite it
    shopt -s histappend

    # Save multi-line commands as one command
    shopt -s cmdhist

    # Record each line as it gets issued
    PROMPT_COMMAND='history -a'

    # Huge history. Doesn't appear to slow things down, so why not?
    HISTSIZE=500000
    HISTFILESIZE=100000

    # Avoid duplicate entries
    HISTCONTROL="erasedups:ignoreboth"

    # Don't record some commands
    export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"

    # Use standard ISO 8601 timestamp
    # %F equivalent to %Y-%m-%d
    # %T equivalent to %H:%M:%S (24-hours format)
    HISTTIMEFORMAT='%F %T '

    # Enable incremental history search with up/down arrows (also Readline goodness)
    # Learn more about this here: http://codeinthehole.com/writing/the-most-important-command-line-tip-incremental-history-searching-with-inputrc/
    bind '"\e[A": history-search-backward'
    bind '"\e[B": history-search-forward'
    bind '"\e[C": forward-char'
    bind '"\e[D": backward-char'

    ## BETTER DIRECTORY NAVIGATION ##

    # Prepend cd to directory names automatically
    shopt -s autocd 2> /dev/null
    # Correct spelling errors during tab-completion
    shopt -s dirspell 2> /dev/null
    # Correct spelling errors in arguments supplied to cd
    shopt -s cdspell 2> /dev/null
    # cd tab navigation limited to directories only
    complete -d cd

    # This defines where cd looks for targets
    # Add the directories you want to have fast access to, separated by colon
    # Ex: CDPATH=".:~:~/projects" will look for targets in the current working directory, in home and in the ~/projects folder
    CDPATH="."

    # This allows you to bookmark your favorite places across the file system
    # Define a variable containing a path and you will be able to cd into it regardless of the directory you're in
    # shopt -s cdable_vars

    # Examples:
    # export dotfiles="$HOME/dotfiles"
    # export projects="$HOME/projects"
    # export documents="$HOME/Documents"
    # export dropbox="$HOME/Dropbox"


    # prefix
    git_prompt_color () {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        if ! git status | grep "nothing to commit" > /dev/null 2>&1; then
        echo -e "\033[0;31m"
        return 0
        fi
    fi
    echo -e "\033[0;37m"
    }

    USER_COLOUR="\033[1;32m"
    ROOT_COLOUR="\033[1;31m"
    HOST_COLOUR="\033[1;30m"
    DIR_COLOUR="\033[1;34m"
    RESET_COLOUR="\033[0m"

    # Turn the prompt symbol red if the user is root
    if [ $(id -u) -eq 0 ];
    then # you are root, make the prompt red
        export PS1="\[$ROOT_COLOUR\]\u\[$RESET_COLOUR\]@\[$HOST_COLOUR\]\h\[$RESET_COLOUR\] \[$DIR_COLOUR\]\W\[$RESET_COLOUR\] \[\$(git_prompt_color)\]•\[$RESET_COLOUR\] \\$ "
    else
        export PS1="\[$USER_COLOUR\]\u\[$RESET_COLOUR\]@\[$HOST_COLOUR\]\h\[$RESET_COLOUR\] \[$DIR_COLOUR\]\W\[$RESET_COLOUR\] \[\$(git_prompt_color)\]•\[$RESET_COLOUR\] \\$ "
    fi

fi


homeshick --quiet refresh

