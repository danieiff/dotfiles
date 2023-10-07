export GIT_PS1_SHOWDIRTYSTATE=true # unstaged * staged +
export GIT_PS1_SHOWSTASHSTATE=true # stashed $
export GIT_PS1_SHOWUNTRACKEDFILES=true # untracked %
export GIT_PS1_SHOWUPSTREAM=auto # local behind <  ahead >  diverged <>  same =
PS1='\[\e[0;100m\]\u@\h \w $(__git_ps1)\[\e[0m\] '

[ -f ~/.fzf.bash ] && . "$HOME/.fzf.bash"
set -o vi
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
      | fzf --reverse --height 30% --bind "enter:execute(curl -L {} | tar xvz)"
}

gistget() {
  temp=$(curl "https://api.github.com/gists/$1")
  for filename in $(echo "$temp" | yq -r ".files|.[]?|.filename")
  do
    echo "$temp" | yq -r ".files|.[\"$filename\"]|.content" > "$filename"
  done
}

# WSL # NOTE: WSL takes 8 sec to stop completely.
## Snapshots recovering in powershell
# mkdir %UserProfile%/wsl_snapshot
# wsl --export <distro> %UserProfile%/wsl_snapshot/<snapshot>.tar
# mkdir %UserProfile%/wsl_vhdx
# wsl --import <new distro name> %UserProfile%/wsl_vhdx/<new dist> %UserProfile%/wsl_snapshot/<snapshot>.tar
# wsl --distributon <new dist> [--user (an existing user)]

## Android
# mkdir ~/Android && ln -s /mnt/c/Users/Hirohisa/AppData/Local/Android/Sdk ~/Android/sdk
# ln -s ~/Android/Sdk/platform-tools/adb.exe ~/Android/Sdk/platform-tools/adb
# ln -s ~/Android/Sdk/platform-tools/emulator/emulator.exe ~/Android/Sdk/emulator/emulator
ANDROID_HOME=~/Android/sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools
alias emu="$ANDROID_HOME/emulator/emulator @Pixel_4_API_30"
alias emu-list="$ANDROID_HOME/emulator/emulator -list-avds"
alias rn-expo="REACT_NATIVE_PACKAGER_HOSTNAME=$(/mnt/c/Windows/system32/ipconfig.exe | grep -m 1 'IPv4 Address' | sed 's/.*: //') npx expo start"
#alias adb=adb.exe
