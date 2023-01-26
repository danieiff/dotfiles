# Bash
shopt -s histappend # append to the history file, don't overwrite it
shopt -s checkwinsize # update LINES and COLUMNS with the window size after each command 
shopt -s autocd
shopt -s direxpand # stop escape "$" during tab completion

## Completion 
bind 'set completion-ignore-case on'
bind 'set completion-display-width 0'
bind 'TAB:menu-complete'
eval "`npm completion`"
[ -f ~/.fzf.bash ] && . ~/.fzf.bash

export COLORTERM=truecolor
## Prompt
# source /usr/lib/git-core/git-sh-prompt
GIT_PS1_SHOWDIRTYSTATE=true # changes unstaged(*) staged(+)
GIT_PS1_SHOWSTASHSTATE=true # stashed($)
GIT_PS1_SHOWUNTRACKEDFILES=true # untracked(%)
GIT_PS1_SHOWUPSTREAM=auto # local behind(<) ahead(>) diverged(<>) same(=)
# PS1='\[\e[0;100m\]\u@\h \A \w $(__git_ps1 "[%s]")\[\e[0m\]\$ '
PS1='\[\e[0;100m\]\u@\h \A \w $(__git_ps1)\[\e[0m\]\$ '

## Alias
### sh
alias v='nvim'
alias trash='gio trash'
alias trash-empty='rm -rf ~/.local/share/Trash'
alias ls='ls --color'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
### git
alias g='git'
#### add
alias a='git add'
alias au='git add -u'
alias ap='git add -u -p'
#### commit
alias cm='git commit'
alias cmm='git commit -m'
alias cma='git commit --amend'
##### add & commit
alias ac='git add -u && git commit'
#### checkout
alias co='git checkout'
alias cob='git checkout -b'
#### branch
alias br='git branch'
alias brv='git branch -vv'
alias brd='git branch -d'
alias brD='git branch -D'
#### status
alias s='git status -s'
#### log
alias l='git log -7 --name-status --oneline'
#### diff
alias df='git diff'
#### cherry-pick
alias chp='git cherry-pick'
#### reset
alias rst='git reset'
#### merge
alias m='git merge'
#### remote
alias rmt='git remote'
alias rmtv='git remote -v'
#### fetch
alias f='git fetch'
#### pull
alias pl='git pull'
#### push
alias psh='git push'

#  skip = update-index --skip-worktree
#  noskip = update-index --no-skip-worktree
#  ls-skip = ls-files -v | grep ^S
#  conflicts = ls-files -u | cut -f 2 | sort -u
#  #
#  mg = merge --no-ff
#  mgff = merge --ff
#  log1 = log -1
#  log2 = log -2
#  log3 = log -3
#  logo = log --oneline
#  logn = log --name-status --oneline
  

# WSL

# wsl distro common setting (8 sec takes till updates appear) %UserProfile%/.wslconfig << [interop]\nappendWindowsPath = false
# https://learn.microsoft.com/en-us/windows/wsl/wsl-config#interop

# Snapshots recovering in powershell
# mkdir %UserProfile%/wsl_snapshot
# wsl --export <distro> %UserProfile%/wsl_snapshot/<snapshot>.tar
# mkdir %UserProfile%/wsl_vhdx
# wsl --import <new distro name> %UserProfile%/wsl_vhdx/<new dist> %UserProfile%/wsl_snapshot/<snapshot>.tar
# wsl --distributon <new dist> [--user (an existing user)]

# echo foo | clip.exe

export PATH=$PATH:$(wslpath "$(wslvar USERPROFILE)")/AppData/Local/Microsoft\ VS\ Code/bin # VSCode "code" command
export PATH=$PATH:/mnt/c/Windows/System32:/mnt/c/Windows/System32/WindowsPowershell/v1.0 

export PATH=$PATH:~/.config/lua-lsp/bin
