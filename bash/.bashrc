# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
#export PATH

# Configure certain dirs in ~/bin to be in my path
#PATH="$HOME/bin/bash:$HOME/bin/bash/udemy_bash_course:$PATH"
#export PATH
PATH="$HOME/.emacs.d/bin:$PATH"
export PATH

umask 0002										# make sharing directories easier
export HISTCONTROL=ignoredups	# Ignore duplicates in history
export HISTSIZE=1000					# A sane default for this

# Set vi/m mode
export EDITOR=vim
set -o vi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

alias l.='ls -d .* --color=auto'
alias ll='ls -l --color=auto'
alias emacs="emacs -nw"				# run emacs in terminal always
export LEDGER_FILE=~/finance/2021.journal

# Alias vi/m to vimx so that I can have +clipboard support
alias vi=vimx				
alias vim=vimx
alias wiki='vim ~/wiki/_index.md'	# alias 'wiki' to VimWiki Index
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
