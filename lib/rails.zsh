alias ber='bundle exec rspec'
alias bec='bundle exec cucumber'
alias berb='bundle exec rspec -b'
alias becb='bundle exec cucumber -b'
alias bess='bundle exec script/server'

# Rails 2 and Rails 3 console
function rc {
  if [ -e "./script/console" ]; then
    ./script/console $@
  else
    rails console $@
  fi
}

# Rails 2 and Rails 3 server
function rs {
  if [ -e "./script/server" ]; then
    bundle exec ./script/server $@
  else
    rails server $@
  fi
}
