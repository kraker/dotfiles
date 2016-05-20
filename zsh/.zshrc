# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd extendedglob nomatch notify
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install
#
# The following lines were added by compinstall
zstyle :compinstall filename '/home/akraker/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

###### Lines configured by me ######

# Environment variables
COLORFGBG="default,default" # Necessary for proper mutt transparent bg
PATH=~/bin:$PATH		# Add ~/bin to $PATH
EDITOR=nvim
GNUPGHOME=~/.gnupg
GPG_TTY=$(tty)
export GPG_TTY

# start ssh-agent and add seed with github key
eval "$(ssh-agent -s)"
#ssh-add ~/.ssh/github
ssh-add ~/.ssh/gitlab

# Colored prompt
autoload -U promptinit
promptinit
prompt grml theme 

#------------------------------------------------
#	Aliases
#------------------------------------------------

alias makepkg="makepkg -sic"
alias la="ls -a"
alias ll="ls -la"
alias cl='clear && screenfetch'

# Todo.txt
alias t='todo.sh'

# Update Mirror list
alias udmirrors="sudo reflector --verbose --country 'United States' -l 200 -p http --sort rate --save /etc/pacman.d/mirrorlist"

# List installed packages by size
alias lapkg="expac -H M '%m\t%n' | sort -h"
# List download size of package(s)
alias lsdpkg="expac -S -H M '%k\t%n'"
# List all packages not in 'base' or 'base-devel' with size and description
alias lspkg="expac -H M \"%011m\t%-20n\t%10d\" \$( comm -23 <(pacman -Qqen|sort) <(pacman -Qqg base base-devel|sort) ) | sort -n"

# tty-clock
alias clock="tty-clock"

#------------------------------------------------


# better completions with menu and autocomplete aliases
zstyle ':completion:*' menu select
setopt completealiases

# Help command like bash

#autoload -U run-help
#autoload run-help-git
#autoload run-help-svn
#autoload run-help-svk
#unalias run-help
#alias help=run-help

# Ignore duplicates in history
setopt HIST_IGNORE_DUPS

# Syntax highlighting in less
export LESSOPEN="| /usr/bin/source-highlight-esc.sh %s"
export LESS='-R '

# grml settings
export GRML_DISPLAY_BATTERY=1

# zsh-syntax-highlighting *must be at EOF!
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Show Arch + Info on startup
screenfetch

