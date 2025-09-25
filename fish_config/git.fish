# Git Configuration for Fish Shell
# This file contains both git aliases and abbreviations consolidated

# =============================================================================
# GIT ABBREVIATIONS (expandable shortcuts)
# =============================================================================

# Basic git operations
abbr -a gs git status
abbr -a ga git add
abbr -a gaa git add .
abbr -a gc git commit
abbr -a gcm git commit -m
abbr -a gca git commit --amend
abbr -a gp git push
abbr -a gpl git pull
abbr -a gf git fetch

# Git branching and merging
abbr -a gb git branch
abbr -a gba git branch -a
abbr -a gco git checkout
abbr -a gcb git checkout -b
abbr -a gm git merge
abbr -a gr git rebase
abbr -a gri git rebase -i

# Git logging and diff
abbr -a gl git log --oneline
abbr -a gd git diff
abbr -a gdc git diff --cached
abbr -a gds git diff --staged
abbr -a glog git log --graph --pretty=format:\'%Cred%h%Creset -%C\(yellow\)%d%Creset %s %Cgreen\(%cr\) %C\(bold blue\)<%an>%Creset\' --abbrev-commit

# Git stash operations
abbr -a gst git stash
abbr -a gstp git stash pop
abbr -a gstl git stash list
abbr -a gstd git stash drop

# Git remote operations
abbr -a gra git remote add
abbr -a grv git remote -v
abbr -a gru git remote update

# Git reset operations
abbr -a grh git reset HEAD
abbr -a grhh git reset HEAD --hard
abbr -a grsh git reset --soft HEAD~1

# =============================================================================
# GIT ALIASES (direct command replacements)
# =============================================================================

# Extended status and information
alias gss 'git status --short'
alias gap 'git add -p'  # Add patches interactively
alias gcan 'git commit --amend --no-edit'

# Extended branching
alias gbd 'git branch -d'
alias gbD 'git branch -D'
alias gcmain 'git checkout main && git pull'
alias gcdevelop 'git checkout develop && git pull'
alias gmaster 'git checkout master && git pull'

# Extended remote operations
alias gfa 'git fetch --all'
alias gpo 'git push origin'
alias gpom 'git push origin main'
alias gpod 'git push origin develop'
alias gpforce 'git push --force-with-lease'

# Extended rebasing and merging
alias grc 'git rebase --continue'
alias grab 'git rebase --abort'
alias gmnoff 'git merge --no-ff'

# Stashing extended
alias gsts 'git stash show'
alias gstc 'git stash clear'

# Reset operations extended
alias grmh 'git reset --mixed HEAD~1'
alias gclean 'git clean -fd'

# Tagging
alias gt 'git tag'
alias gtl 'git tag -l'
alias gtd 'git tag -d'

# Utilities
alias gignore 'git update-index --assume-unchanged'
alias gunignore 'git update-index --no-assume-unchanged'
alias gwho 'git shortlog -sn'
alias gcount 'git rev-list --count HEAD'
alias gblame 'git blame'
alias gshow 'git show'

# Advanced operations
alias gcp 'git cherry-pick'
alias gcpa 'git cherry-pick --abort'
alias gcpc 'git cherry-pick --continue'

# Workflow shortcuts
alias gwip 'git add -A && git commit -m "WIP"'
alias gunwip 'git log -n 1 | grep -q -c "WIP" && git reset HEAD~1'
alias gfix 'git commit --fixup'
alias gsquash 'git commit --squash'
