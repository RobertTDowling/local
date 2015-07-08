# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

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
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
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

# some more ls aliases
# alias ll='ls -alF'
# alias la='ls -A'
# alias l='ls -CF'

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
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

##############################################################################

if [ -f /etc/bash_completion.d/git ]; then
    . /etc/bash_completion.d/git
fi

PATH=~/local/bin:~/Android/Sdk/platform-tools:$PATH

export LESS=-M
export GIT_PAGER=
export MANPAGER='/usr/bin/less -isM'
export LC_COLLATE="C"
export EDITOR=emacs
# export PRINTER=hp4050
BOLD=`tput smso`
NORM=`tput rmso`
export PS1=$BOLD'\u@\h:$SHLVL:\w'$NORM'\n\A % '
# export GIT_PS1_SHOWDIRTYSTATE=1
# export PS1=$BOLD'\u@\h:$SHLVL:\w'$NORM'\n\A $(__git_ps1) % '
# b=$(tput rev)
# a=$(tput sgr0)
# export PS1="\\[$b\\]\${debian_chroot:+(\$debian_chroot)}\h:\u:\w\\[$a\\]\n\t \$ 

#export emacsfont='-b&h-lucidatypewriter-medium-r-normal-sans'
# List them: xlsfonts | grep -- -m- | grep lucida
#   10,12,14,18,19,20
# alias e='emacs -fn 10x20 -geometry 80x40'
alias e='emacs'
alias dir='ls -l'
alias dus='du -s * | sort -n'
alias rd='sudo chown rob:rob'

# alias serial='sudo chmod a+rw /dev/ttyUSB0; sleep 1; putty &'
# alias dftp="sudo \$HT/dftp-client.py"
# alias update="\$HT/send-surgeon/update-firmware-dftp2.sh"

# To use Ubuntu flashing tools
# export HT=$HOME/linux/LinuxDist_LF2000/host_tools

# To build a kernel...
# export ARCH=arm
# export CROSS_COMPILE=arm-angstrom-linux-uclibceabi-
# export E2K_ROOTFS_PATH=~/builds
# export LOCALVERSION=
# export TARGET_MACH=nxp3200_rio_defconfig

# To use Angstrom
# export PATH=/opt/angstrom-denzil/sysroots/i686-angstromsdk-linux/usr/bin/armv7a-vfp-angstrom-linux-uclibceabi/:$PATH
