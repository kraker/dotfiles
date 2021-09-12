# .bashrc
#
# Author: Alex Kraker
# Email: alex@alexkraker.com
# Github: github.com/kraker

# Load ble.sh by default in interactive sessions of `bash`
# See: https://github.com/akinomyoga/ble.sh
[[ $- == *i* ]] && source ~/.local/share/blesh/ble.sh --noattach

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi

# Configure certain dirs in ~/bin to be in my path
#PATH="$HOME/bin/bash:$HOME/bin/bash/udemy_bash_course:$PATH"

# I no longer use emacs...
#PATH="$HOME/.emacs.d/bin:$PATH"
export PATH
# Go paths
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

umask 0002                              # make sharing directories easier
export HISTCONTROL=ignoredups           # Ignore duplicates in history
export HISTSIZE=5000                    # A sane default for this

# Set vi/m mode
export EDITOR=nvim
set -o vi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

alias l.='ls -d .* --color=auto'
alias ll='ls -l --color=auto'
alias emacs="emacs -nw"                 # run emacs in terminal always
export LEDGER_FILE=~/finance/2021.journal

# Alias vi/m, to nvim 
alias vi=nvim				
alias vim=nvim
alias wiki='nvim ~/wiki/_index.md'	# alias 'wiki' to VimWiki Index

# Timewarrior aliases
alias ts='timew summary :ids'
alias t='timew'
alias st='start'
alias sp='stop'

# Attach to ble.sh (this should be last line of .bashrc)
[[ ${BLE_VERSION-} ]] && ble-attach
