#!/bin/zsh

# Push and pop directories on directory stack
alias pu='pushd'
alias po='popd'

alias ss='script/server'
alias sg='ruby script/generate'
alias sd='ruby script/destroy'
alias sp='ruby script/plugin'
alias ssp='ruby script/spec'
alias rdbm='rake db:migrate'
alias sd='ruby script/server --debugger'
alias devlog='tail -f log/development.log'

# Basic directory operations
alias .='pwd'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias -- -='cd -'

# Super user
alias _='sudo'

# Show history
alias history='fc -l 1'

# List direcory contents
alias lsa='ls -lah'
alias l='ls -la'
alias ll='ls -alr'
alias sl=ls # often screw this up

alias sgem='sudo gem'

# Find ruby file
alias rfind='find . -name *.rb | xargs grep -n'
alias afind='ack-grep -il'

# Misc
alias sauce='source ~/.zshrc'
alias dotfiles='source ~/.zshrc'
alias mate='mvim'
alias b='bundle install && /usr/local/Cellar/ctags/5.8/bin/ctags -R `rvm gemdir`'
alias rsa='cat ~/.ssh/id_rsa.pub'
