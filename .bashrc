# Bash
shopt -s histappend # append to the history file, don't overwrite it
shopt -s checkwinsize # update LINES and COLUMNS with the window size after each command 
shopt -s autocd
shopt -s direxpand # stop escape "$" during tab completion
shopt -s expand_aliases # enable aliase, function in non-interactive shell (use in neovim)

set -o vi

## Completion
if [ -t 1 ] 
then
  bind 'set completion-ignore-case on'
  bind 'set completion-display-width 0'
  bind 'TAB:menu-complete'
fi
eval "$(npm completion)"
[ -f ~/.fzf.bash ] && . "$HOME"/.fzf.bash

## Prompt
# source /usr/lib/git-core/git-sh-prompt
export GIT_PS1_SHOWDIRTYSTATE=true # changes unstaged(*) staged(+)
export GIT_PS1_SHOWSTASHSTATE=true # stashed($)
export GIT_PS1_SHOWUNTRACKEDFILES=true # untracked(%)
export GIT_PS1_SHOWUPSTREAM=auto # local behind(<) ahead(>) diverged(<>) same(=)
# PS1='\[\e[0;100m\]\u@\h \A \w $(__git_ps1 "[%s]")\[\e[0m\]\$ '
PS1='\[\e[0;100m\]\u@\h \A \w $(__git_ps1)\[\e[0m\] '

## Alias
alias nvim="/usr/bin/nvim --server \$NVIM --remote-silent"
alias v="/usr/bin/nvim --server \$NVIM --remote-silent"
alias shrc='nvim ~/.bashrc'
alias .shrc='source ~/.bashrc'
alias trash='gio trash'
alias trash-empty='rm -rf ~/.local/share/Trash'
alias ll='ls -alF --color'
alias la='ls -A --color'

### git
alias g='git'
alias a='git add'
alias au='git add -u'
alias ap='git add -u -p'
alias cm='git commit'
alias cmm='git commit -m'
alias cma='git commit --amend'
alias ac='git add -u && git commit'
alias co='git checkout'
alias br='git branch'
alias brd='git branch -d'
alias s='git status -s'
alias df='git diff'
alias chp='git cherry-pick'
alias rst='git reset'
alias m='git merge'
alias rmt='git remote'
alias f='git fetch'
alias pl='git pull'
alias psh='git push'

alias skip='git update-index --skip-worktree'
alias noskip='git update-index --no-skip-worktree'
alias ls-skip='git ls-files -v | grep ^S'
alias conflicts='git ls-files -u | cut -f 2 | sort -u'

alias l='git log'
alias lg='git log -7 --name-status --oneline'
alias lgo='git log --oneline'
alias lgn='git log --name-status --oneline'


lk() {
  local find_options="-maxdepth 1"
  for arg in "$@"; do [ "$arg" = "-a" ] && find_options=""; break; done

  local target_files=`echo "$(find . $find_options -type f -o -type l)" \
    | sed 's/\.\///g' \
    | grep -v -e '.jpg' -e '.gif' -e '.png' -e '.jpeg' \
    | sort -r \
    | fzf-tmux -p80% --select-1 --prompt 'nvim ' --preview 'bat --color always {}' --preview-window=right:70%
  `
  [ "$target_files" = "" ] && return
  nvim -p "${target_files[@]}"
}

myselect() {
  readarray -t options <<< "$@"
  select opt in "${options[@]}" "Quit" ; do
    if (( REPLY == 1 + "${#options[@]}" )) ; then break

    elif (( REPLY > 0 && REPLY <= "${#options[@]}" )) ; then
      echo $opt
      break
    fi
  done
}

ghinstall() {
  local download_urls=$(
    curl "https://api.github.com/repos/$1/releases/latest" \
    | grep browser_download_url* \
    | grep -Eo 'https://[^\"]*'
  )
  myselect "$download_urls" | xargs curl -LJ | tar -xz
}

gistget() {
  temp=$(curl -sS https://api.github.com/gists/$1)

  for filename in $(echo "${temp}" | jq -r ".files|.[]?|.filename")
  do
    echo "${temp}" | jq -r ".files|.[\"${filename}\"]|.content" > ${filename}
  done
}


export PATH=$PATH:~/.config/lua-lsp/bin

export PATH=$PATH:/usr/local/zig-linux-x86_64-0.11.0-dev.1507+6f13a725a

export PATH=$PATH:/usr/local/go/bin:~/go/bin

export PATH=$PATH:~/.cargo/bin

alias python=python3


# WSL

# wsl distro common setting (8 sec takes till updates take effects) %UserProfile%/.wslconfig << [interop]\nappendWindowsPath = false
# https://learn.microsoft.com/en-us/windows/wsl/wsl-config#interop

# Snapshots recovering in powershell
# mkdir %UserProfile%/wsl_snapshot
# wsl --export <distro> %UserProfile%/wsl_snapshot/<snapshot>.tar
# mkdir %UserProfile%/wsl_vhdx
# wsl --import <new distro name> %UserProfile%/wsl_vhdx/<new dist> %UserProfile%/wsl_snapshot/<snapshot>.tar
# wsl --distributon <new dist> [--user (an existing user)]

# echo foo | clip.exe
#
#lg()
#{
#    export LAZYGIT_NEW_DIR_FILE=~/.lazygit/newdir
#
#    lazygit "$@"
#
#    if [ -f $LAZYGIT_NEW_DIR_FILE ]; then
#            cd "$(cat $LAZYGIT_NEW_DIR_FILE)"
#            rm -f $LAZYGIT_NEW_DIR_FILE > /dev/null
#    fi
#} # <shift + q> to override

##### export PATH=$PATH:$(wslpath "$(wslvar USERPROFILE)")/AppData/Local/Microsoft\ VS\ Code/bin # VSCode "code" command
export PATH=$PATH:/mnt/c/Windows/System32

## Android
# mkdir ~/Android && ln -s /mnt/c/Users/Hirohisa/AppData/Local/Android/Sdk ~/Android/sdk
# ln -s ~/Android/Sdk/platform-tools/adb.exe ~/Android/Sdk/platform-tools/adb
# ln -s ~/Android/Sdk/platform-tools/emulator/emulator.exe ~/Android/Sdk/emulator/emulator
export ANDROID_HOME=~/Android/sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools
#alias adb=adb.exe
alias emu="$ANDROID_HOME/emulator/emulator @Pixel_4_API_30"
alias emu-list="$ANDROID_HOME/emulator/emulator -list-avds"


## Run in Powershell as Admin
# Foreach ( $port in 19000,19001,19002 ) { netsh interface portproxy add v4tov4 listenport=$port connectport=$port connectaddress=$($(wsl hostname -I).Trim()) }
# Foreach ( $dir in "Inbound","Outbound") { New-NetFireWallRule -DisplayName 'WSL Expo ports for LAN development' -Direction $dir -LocalPort 19000-19002 -Action Allow -Protocol TCP }
##### alias rn-expo="REACT_NATIVE_PACKAGER_HOSTNAME=$(ipconfig.exe | grep -m 1 'IPv4 Address' | sed 's/.*: //') npx expo start"

# sudo ln -s /mnt/c/Program\ Files\ \(x86\)/Google/Chrome/Application/chrome.exe /usr/bin/chrome
