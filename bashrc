# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export WIZARD_DIR=/home/$USER/wizard
source $HOME/ros_noetic/install_isolated/setup.bash
source $HOME/wizard/env/setup.bash
source $HOME/wizard/devel/setup.bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

alias v="/home/saw/neovim/usr/bin/nvim"

export TERM="xterm"

export OPENAI_API_KEY=""
export PATH=$HOME/.local/bin:$PATH

# Define moon colors
BLACK='\[\e[38;2;192;153;233m\]'
RED='\[\e[38;2;255;117;110m\]'
GREEN='\[\e[38;2;195;232;120m\]'
YELLOW='\[\e[38;2;255;199;119m\]'
BLUE='\[\e[38;2;130;170;207m\]'
MAGENTA='\[\e[38;2;252;167;234m\]'
CYAN='\[\e[38;2;137;221;255m\]'
WHITE='\[\e[38;2;200;211;245m\]'
RESET='\[\e[0m\]' # Reset color

# Set prompt colors using moon colors
export PS1="$BLACK\u$RESET@$BLUE\h$RESET:$CYAN\w$RESET\$ "

export PATH=$PATH:$HOME/go/bin


export WALLIFY_DIR=/home/$USER/wallify
alias cdf="cd $WALLIFY_DIR/frontend"
alias cdb="cd $WALLIFY_DIR/backend"
alias dev-up="docker compose -f \$WALLIFY_DIR/docker/docker-compose.dev.yml up --build"
alias dev-down="docker compose -f \$WALLIFY_DIR/docker/docker-compose.dev.yml down"
alias prod-up="docker compose -f \$WALLIFY_DIR/docker/docker-compose.prod.yml up --build"
alias dev-reset="docker compose -f \$WALLIFY_DIR/docker/docker-compose.dev.yml down -v"

export PATH="$HOME/.npm-global/bin:$PATH"

# Luminous Stuff
source /home/alex/athena/env/setup.bash

# Hide the stuff after hostname to make it cleaner
PS1='\[\033[36m\]\u\[\033[m\]:\[\033[33;1m\]\w\[\033[m\]$(parse_git_branch) $ '

alias RUN_ALL="/home/alex/Desktop/luminous/run_all.sh"
export LUMI_UI_DIR=/home/$USER/athena/src/lumi_ui
alias WEB_PROD="docker compose -f \$LUMI_UI_DIR/docker/docker-compose.prod.yml up --build -d"
alias WEB_PROD_DOWN="docker compose -f \$LUMI_UI_DIR/docker/docker-compose.prod.yml down"
alias ui="cd $LUMI_UI_DIR"
alias WEB_DEV="docker compose -f \$LUMI_UI_DIR/docker/docker-compose.dev.yml up --build"
alias WEB_DOWN="docker compose -f \$LUMI_UI_DIR/docker/docker-compose.dev.yml down"
alias WEB_RESET="docker compose -f \$LUMI_UI_DIR/docker/docker-compose.dev.yml down -v"
alias WEB_PROD="docker compose -f \$LUMI_UI_DIR/docker/docker-compose.yml up --build -d"
alias WEB_PROD_RESET="docker compose -f \$LUMI_UI_DIR/docker/docker-compose.prod.yml down -v"

eval "$(zoxide init bash)"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
