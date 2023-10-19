eval "$(zellij setup --generate-auto-start bash)"
source /etc/bash_completion.d/git-prompt
[ -f ~/.fzf.bash ] && . ~/.fzf.bash

export GIT_PS1_SHOWDIRTYSTATE=true # unstaged * staged +
export GIT_PS1_SHOWSTASHSTATE=true # stashed $
export GIT_PS1_SHOWUNTRACKEDFILES=true # untracked %
export GIT_PS1_SHOWUPSTREAM=auto # local behind < ,ahead > ,diverged <> ,same =
export PS1='\[\e[0;100m\]\u@\h \w $(__git_ps1)\[\e[0m\] '

[ -f ~/.fzf.bash ] && . ~/.fzf.bash
shopt -s expand_aliases # Enable alias, function in login shell

alias nvim="/usr/bin/nvim --server \$NVIM --remote-silent"
alias v="/usr/bin/nvim --server \$NVIM --remote-silent"
alias shrc='nvim ~/.bashrc'
alias .shrc='source ~/.bashrc'
alias trash='gio trash'
alias trash-empty='rm -rf ~/.local/share/Trash'
alias ll='ls -alF --color'
alias la='ls -A --color'

alias co='git checkout'
alias br='git branch'
alias s='git status -s'
alias l='git log'
alias df='git diff'
alias chp='git cherry-pick'
alias rst='git reset'
alias pl='git pull'
alias skip='git update-index --skip-worktree'
alias noskip='git update-index --no-skip-worktree'
alias ls-skip='git ls-files -v | grep ^S'

export PATH=$PATH:/usr/local/go/bin:~/go/bin
export PATH=$PATH:~/.cargo/bin
alias python=python3
alias sail="vendor/bin/sail"

ghinstall() {
  curl "https://api.github.com/repos/$1/releases/latest" \
    | grep -Po "(?<=browser_download_url\": \")https://[^\"]*" \
    | fzf --reverse --height 30% --bind "enter:execute( curl -L {} | tar xvz )+abort"
}

gistget() {
  local temp
  temp=$(curl "https://api.github.com/gists/$1")
  for filename in $(echo "$temp" | yq -r ".files|.[]?|.filename")
  do
    echo "$temp" | yq -r ".files|.[\"$filename\"]|.content" > "$filename"
  done
}

# WSL
## Android
# mkdir ~/Android && ln -s /mnt/c/Users/Hirohisa/AppData/Local/Android/Sdk ~/Android/sdk
# ln -s ~/Android/Sdk/platform-tools/adb.exe ~/Android/Sdk/platform-tools/adb
# ln -s ~/Android/Sdk/platform-tools/emulator/emulator.exe ~/Android/Sdk/emulator/emulator
ANDROID_HOME=~/Android/sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools
alias emu='$ANDROID_HOME/emulator/emulator @Pixel_4_API_30'
alias emu-list='$ANDROID_HOME/emulator/emulator -list-avds'

# Foreach ( $port in 19000,19001,19002 ) { netsh interface portproxy add v4tov4 listenport=$port connectport=$port connectaddress=$($(wsl hostname -I).Trim()) }
# Foreach ( $dir in "Inbound","Outbound" ) { New-NetFireWallRule -DisplayName 'WSL Expo ports for LAN development' -Direction $dir -LocalPort 19000-19002 -Action Allow -Protocol TCP }
alias rn-expo='REACT_NATIVE_PACKAGER_HOSTNAME=$(/mnt/c/Windows/system32/ipconfig.exe | grep -m 1 "IPv4 Address" | sed "s/.*: //") npx expo start'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

