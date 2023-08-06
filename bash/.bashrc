# .bashrc
#
# Author: Alex Kraker
# Email: alex@alexkraker.com
# Github: github.com/kraker

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

#######################
# Runtime Environment #
#######################

# Set PATH
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
  PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi

# Go PATH
#export GOPATH=$HOME/go
#export PATH=$PATH:$GOPATH/bin

# Other confs that are 'nice to have...'
umask 0002                              # make sharing directories easier
export HISTCONTROL=ignoredups           # Ignore duplicates in history
export HISTSIZE=5000                    # A sane default for this

# Use less for pager
export PAGER=less
export MANPAGER=less

# BASH Prompt
# See: https://tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html
# PS1="\[\033[0;32m\][\u@\h:\[\033[0;31m\]\w\[\033[0;32m\]]$\[\033[0m\] "

# git-prompt
source ~/.git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1
export PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '

# git-completion
source ~/.git-completion.bash

###########
# Aliases #
###########

alias l.='ls -d .* --color=auto'
alias ll='ls -lA --color=auto'

# emacs
alias emacs="emacs -nw"                 # run emacs in terminal always

# texinfo using vi keybindings
alias info='info --vi-keys'

# SSH
#alias ssh='TERM=linux ssh'

# Timewarrior
#alias t='timew'                         # t     - timew
#alias ts='timew summary :ids'           # ts    - summary
#alias tt='timew track'                  # tt    - track
#alias td='timew delete'                 # td    - delete
#alias tst='timew start'                 # tst   - start
#alias tsp='timew stop'                  # tsp   - stop

# Taskwarrior
#alias tw='task'                         # tw    - task
#alias twa='task add'                    # twa   - task add

#############
# Functions #
#############

taocl() {
  curl -s https://raw.githubusercontent.com/jlevy/the-art-of-command-line/master/README.md |
  sed '/cowsay[.]png/d' |
  pandoc -f markdown -t html |
  xmlstarlet fo --html --dropdtd |
  xmlstarlet sel -t -v "(html/body/ul/li[count(p)>0])[$RANDOM mod last()+1]" |
  xmlstarlet unesc | fmt -80 | iconv -t US | cowsay
}

# SSH agent
# https://gist.github.com/darrenpmeyer/e7ad217d929f87a7b7052b3282d1b24c
ssh_pid_file="$HOME/.config/ssh-agent.pid"
SSH_AUTH_SOCK="$HOME/.config/ssh-agent.sock"
if [ -z "$SSH_AGENT_PID" ]
then
	# no PID exported, try to get it from pidfile
	SSH_AGENT_PID=$(cat "$ssh_pid_file")
fi

if ! kill -0 $SSH_AGENT_PID &> /dev/null
then
	# the agent is not running, start it
	rm "$SSH_AUTH_SOCK" &> /dev/null
	>&2 echo "Starting SSH agent, since it's not running; this can take a moment"
	eval "$(ssh-agent -s -a "$SSH_AUTH_SOCK")"
	echo "$SSH_AGENT_PID" > "$ssh_pid_file"
	ssh-add -A 2>/dev/null

	>&2 echo "Started ssh-agent with '$SSH_AUTH_SOCK'"
# else
# 	>&2 echo "ssh-agent on '$SSH_AUTH_SOCK' ($SSH_AGENT_PID)"
fi
export SSH_AGENT_PID
export SSH_AUTH_SOCK
