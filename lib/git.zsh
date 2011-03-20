# get the name of the branch we are on
function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

function gup
{
	# subshell for `set -e` and `trap`
	(
		set -e # fail immediately if there's a problem

		# fetch upstream changes
		git fetch

		BRANCH=$(git describe --contains --all HEAD)
		if [ -z "$(git config branch.$BRANCH.remote)" -o -z "$(git config branch.$BRANCH.merge)" ]
		then
			echo "\"$BRANCH\" is not a tracking branch." >&2
			exit 1
		fi

		# create a temp file for capturing command output
		TEMPFILE="`mktemp -t gup.XXXXXX`"
		trap '{ rm -f "$TEMPFILE"; }' EXIT

		# if we're behind upstream, we need to update
		if git status | grep "# Your branch" > "$TEMPFILE"
		then

			# extract tracking branch from message
			UPSTREAM=$(cat "$TEMPFILE" | cut -d "'" -f 2)
			if [ -z "$UPSTREAM" ]
			then
				echo Could not detect upstream branch >&2
				exit 1
			fi

			# can we fast-forward?
			CAN_FF=1
			grep -q "can be fast-forwarded" "$TEMPFILE" || CAN_FF=0

			# stash any uncommitted changes
			git stash | tee "$TEMPFILE"
			[ "${PIPESTATUS[0]}" -eq 0 ] || exit 1

			# take note if anything was stashed
			HAVE_STASH=0
			grep -q "No local changes" "$TEMPFILE" || HAVE_STASH=1

			if [ "$CAN_FF" -ne 0 ]
			then
				# if nothing has changed locally, just fast foward.
				git merge --ff "$UPSTREAM"
			else
				# rebase our changes on top of upstream, but keep any merges
				git rebase -p "$UPSTREAM"
			fi

			# restore any stashed changed
			[ "$HAVE_STASH" -ne 0 ] && git stash pop -q

		fi

	)
}

parse_git_dirty () {
  if [[ $((git status 2> /dev/null) | tail -n1) != "nothing to commit (working directory clean)" ]]; then
    echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
  else
    echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi
}

#
# Will return the current branch name
# Usage example: git pull origin $(current_branch)
#
function current_branch() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo ${ref#refs/heads/}
}

# Aliases
alias g='git'
alias gs='git status'
alias gl='git pull'
alias gp='git push'
alias gd='git diff'
alias gds='git diff --staged'
alias gdv='git diff -w "$@" | vim -R -'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gch='git checkout'
alias gb='git branch'
alias gba='git branch -a'
alias gbr='git branch -r'
alias gcount='git shortlog -sn'
alias gcp='git cherry-pick'
alias gcom='git checkout master'
alias gco='git checkout'
alias gcot='git checkout -t'
alias ga='git add'
alias git lg='git lg'
alias glg='git lg'
alias gf='git fetch'
alias gsw='git show'
alias gswp='git show -p'
