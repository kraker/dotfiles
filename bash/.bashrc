# .bashrc

######################################################################
#
#
#           ██████╗  █████╗ ███████╗██╗  ██╗██████╗  ██████╗
#           ██╔══██╗██╔══██╗██╔════╝██║  ██║██╔══██╗██╔════╝
#           ██████╔╝███████║███████╗███████║██████╔╝██║
#           ██╔══██╗██╔══██║╚════██║██╔══██║██╔══██╗██║
#           ██████╔╝██║  ██║███████║██║  ██║██║  ██║╚██████╗
#           ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝
#
#
######################################################################

# Author: Alex Kraker
# Email: alex@alexkraker.com
# GitHub: https://github.com/kraker/dotfiles/

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# Sensible BASH
# https://github.com/mrzool/bash-sensible/
# cd ~/bin && wget https://raw.githubusercontent.com/mrzool/bash-sensible/master/sensible.bash
if [ -f ~/bin/sensible.bash ]; then
  source ~/bin/sensible.bash
else
  echo "Installing Sensible BASH..."
  mkdir -p ~/bin
  cd ~/bin
  wget https://raw.githubusercontent.com/mrzool/bash-sensible/master/sensible.bash
  echo "Sensible BASH installed."
  source ~/bin/sensible.bash
fi

#######################
# Runtime Environment #
#######################

# Set PATH
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
  PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi

# Go PATH
#export GOPATH=$HOME/go
#export PATH=$PATH:$GOPATH/bin

# Permissions
umask 0002                              # Make sharing directories easier

# Pagers
export PAGER=less
export MANPAGER=less

# BASH Prompt
# https://starship.rs/
eval "$(starship init bash)"

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

# Git
# https://www.freecodecamp.org/news/bashrc-customization-guide/
alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gcm='git commit -m'
alias gl='git log --oneline'
alias gb='git checkout -b'
alias gd='git diff'

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

complete -C /usr/bin/terraform terraform

# >>>> Vagrant command completion (start)
. /opt/vagrant/embedded/gems/gems/vagrant-2.4.1/contrib/bash/completion.sh
# <<<<  Vagrant command completion (end)
