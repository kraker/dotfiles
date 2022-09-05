# .bashrc
#
# Author: Alex Kraker
# Email: alex@alexkraker.com
# Github: github.com/kraker

# Load ble.sh by default in interactive sessions of `bash`
# See: https://github.com/akinomyoga/ble.sh
#[[ $- == *i* ]] && source ~/.local/share/blesh/ble.sh --noattach

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

#### Runtime Environment ####

## PATH ##

if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
  PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi

# Go paths
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# Configure certain dirs in ~/bin to be in my path
#PATH="$HOME/bin/bash:$HOME/bin/bash/udemy_bash_course:$PATH"

# I no longer use emacs...
#PATH="$HOME/.emacs.d/bin:$PATH"
#export PATH

## Other Env Vars ##

# Other confs that are 'nice to have...'
umask 0002                              # make sharing directories easier
export HISTCONTROL=ignoredups           # Ignore duplicates in history
export HISTSIZE=5000                    # A sane default for this

# Use less for pager
export PAGER=less
# Colors for less as PAGER and MANPAGER
#export LESS='-RXF --use-color -Dd+r$Du+b'
export MANPAGER=less
#export LESS_TERMCAP_mb=$'\e[1;35m'
#export LESS_TERMCAP_md=$'\e[1;35m'
#export LESS_TERMCAP_me=$'\e[0m'
#export LESS_TERMCAP_se=$'\e[0m'
#export LESS_TERMCAP_so=$'\e[01;35m'
#export LESS_TERMCAP_ue=$'\e[0m'
#export LESS_TERMCAP_us=$'\e[1;4;35m'

# Set vi/m mode
if [[ "$(command -v nvim)" ]]; then
  export EDITOR='nvim'
  #export MANPAGER='nvim +Man!'
  #export MANWIDTH=999
fi

#if [[ $- == *i* ]]; then                # In interactive session
#  set -o vi                           # set shell to 'vi-mode'
#fi

export LEDGER_FILE=~/finance/2021.journal
# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

#### END Runtime Environment ####


#### Aliases ####

alias l.='ls -d .* --color=auto'
alias ll='ls -lA --color=auto'

# emacs
alias emacs="emacs -nw"                 # run emacs in terminal always

# vi, vim, nvim
#alias vi=nvim				
#alias vim=nvim
alias wiki='nvim ~/wiki/_index.md'	# alias 'wiki' to VimWiki Index

# texinfo using vi keybindings
alias info='info --vi-keys'

# SSH
alias ssh='TERM=linux ssh'

# Timewarrior
alias t='timew'                         # t     - timew
alias ts='timew summary :ids'           # ts    - summary
alias tt='timew track'                  # tt    - track
alias td='timew delete'                 # td    - delete
alias tst='timew start'                 # tst   - start
alias tsp='timew stop'                  # tsp   - stop

# Taskwarrior
alias tw='task'                         # tw    - task
alias twa='task add'                    # twa   - task add

#### END Aliases ####


#### Functions ####

function taocl() {
  curl -s https://raw.githubusercontent.com/jlevy/the-art-of-command-line/master/README.md |
  sed '/cowsay[.]png/d' |
  pandoc -f markdown -t html |
  xmlstarlet fo --html --dropdtd |
  xmlstarlet sel -t -v "(html/body/ul/li[count(p)>0])[$RANDOM mod last()+1]" |
  xmlstarlet unesc | fmt -80 | iconv -t US | cowsay
}

#### Prompt ####
# See: https://tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html
PS1="\[\033[0;32m\][\u@\h:\[\033[0;31m\]\w\[\033[0;32m\]]$\[\033[0m\] "
# ^ Hopefully this doesn't break line-wrap in my terminal
#PS1="\e[0;35m[\u@\h \e[0;36m\W\e[0m\e[0;35m]\$ \e[0m"
#PS1="\e[0;35m[\u@\h \W]\$ \e[0m"

# Attach to ble.sh (this should be last line of .bashrc)
#[[ ${BLE_VERSION-} ]] && ble-attach
# git-prompt
source ~/.git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1
export PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '
# git-completion
source ~/.git-completion.bash
