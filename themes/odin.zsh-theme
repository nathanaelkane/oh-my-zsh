# ln -s ~/.dotfiles/zsh/zsh-theme my.zsh-theme # Setup my.zsh-theme symlink@ (command must be run from ~/.oh-my-zsh/themes)

function git_branch {
  git branch >/dev/null 2>/dev/null && git_prompt_info && return
  echo '○' # Not in a repository
}

# Show number of stashed items (BinaryMuse)
git_stash() {
  git stash list 2> /dev/null | wc -l | sed -e "s/ *\([0-9]*\)/\ \+\1/g" | sed -e "s/ \+0//"
}

# Prompt PWD
# http://github.com/bjeanes/dot-files/blob/master/shell/prompt.sh
if [ `uname -s` = "Darwin" ]; then
  function prompt_pwd() {
    if [ "$PWD" != "$HOME" ]; then
      printf "%s" `echo $PWD|sed -e 's|/private||' -e "s|^$HOME|~|" -e 's-/\(\.\{0,1\}[^/]\)\([^/]*\)-/\1-g'`
      echo $PWD|sed -e 's-.*/\.\{0,1\}[^/]\([^/]*$\)-\1-'
    else
      echo '~'
    fi
  }
else # defined two for diff systems because Fish did (not entirely sure why)
  function prompt_pwd() {
    case "$PWD" in
      $HOME)
        echo '~'
        ;;
      *)
        printf "%s" `echo $PWD|sed -e "s|^$HOME|~|" -e 's-/\(\.\{0,1\}[^/]\)\([^/]*\)-/\1-g'`
        echo $PWD|sed -n -e 's-.*/\.\{0,1\}.\([^/]*\)-\1-p'
        ;;
    esac
  }
fi

function prompt_color() { # bjeanes
  if [ "$USER" = "root" ]; then
    echo "red"
  else
    if [ -n "$SSH_TTY" ]; then
      echo "blue"
    else
      echo "cyan"
    fi
  fi
}

# Only show user and hostname when connected as root user or via ssh
function user_hostname {
  if [[ "$USER" = "root" || -n "$SSH_TTY" ]]; then
    echo " "`whoami`@`hostname`
  fi
}

# get the name of the branch we are on
function rvm_prompt_info() {
  if [[ -n "$rvm_path" ]]
  then
      [[ -z "$rvm_ruby_string" ]] && return
      if [[ -z "$rvm_gemset_name" && "$rvm_sticky_flag" -ne 1 ]]
      then
        [[ "$rvm_ruby_string" = "system" && ! -s "$rvm_path/config/alias" ]] && return
        grep -q -F "default=$rvm_ruby_string" "$rvm_path/config/alias" && return
      fi
      local full=$(
        "$rvm_path/bin/rvm-prompt" i v g 2> /dev/null |
        sed \
          -e 's/jruby-jruby-/jruby-/' -e 's/ruby-//' \
          -e 's/-@/@/' -e 's/-$//')
      [ -n "$full" ] && echo "($full)"
  fi
}

# %3~ # Shows 3 directories deep
PROMPT='[%{${fg_bold[green]}%}%2~%{${reset_color}%}] %{${fg[$(prompt_color)]}%}»%{${reset_color}%} '
RPROMPT='%{${fg_bold[cyan]}%}$(rvm_prompt_info)%{${reset_color}%} %{${fg_bold[yellow]}%}$(git_branch)%{${reset_color}%}$(git_stash)'

PROMPT2="%{${fg[$(prompt_color)]}%}»%{${reset_color}%} "
RPROMPT2='[%_]'

# Git theming
ZSH_THEME_GIT_PROMPT_PREFIX="±("
ZSH_THEME_GIT_PROMPT_SUFFIX=")"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="*"
# ZSH_THEME_GIT_PROMPT_UNTRACKED="^" # Not implimented in the current oh-my-zsh version.

# The escape codes are surrounded by %{ and %}. These are zsh prompt escapes that tell the shell to disregard the contained characters when
# determining the length of the prompt. This allows zsh to properly position the cursor.
