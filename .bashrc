shopt -s expand_aliases # Enable alias and function in login shell
export EDITOR="/usr/bin/nvim"
alias v="/usr/bin/nvim --server \$NVIM --remote-silent"
alias rc='nvim ~/.bashrc'
alias .rc='source ~/.bashrc'
alias l='ls -alF --color'
alias skip='git update-index --skip-worktree'
alias noskip='git update-index --no-skip-worktree'
alias ls-skip='git ls-files -v | grep ^S'

ghinstall() {
  curl "https://api.github.com/repos/$1/releases/latest" \
    | grep -Po "(?<=browser_download_url\": \")https://[^\"]*" \
    | fzf --reverse --height 30% --bind "enter:execute( curl -L {} | tar xvz )+abort"
}

gistget() {
  local temp=$(curl "https://api.github.com/gists/$1")
  for filename in $(echo "$temp" | yq -r ".files|.[]?|.filename")
  do echo "$temp" | yq -r ".files|.[\"$filename\"]|.content" > "$filename"
  done
}

dev-docker() {
  local docker_home=/home/me
  docker run -it \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v ~/.config/gh:$docker_home/.config/gh \
    -v ~/.cache/nvim/codeium:$docker_home/.cache/nvim/codeium \
    -v .:$docker_home/workspace \
    -e LOCAL_UID="$(id -u "$USER")" \
    -e LOCAL_GID="$(id -g "$USER")" \
    "$@"
}

dev-ssh() {
  ssh -L "${1:-3000}:localhost:${1:-3000} ${3:-user@host}"
}

eval "$(zellij setup --generate-auto-start bash)"
[ -f ~/.fzf.bash ] && . ~/.fzf.bash

if [ "$WSLENV" ]; then
## ReactNative Android
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

eval "$(echo "$PASS" | gnome-keyring-daemon --unlock --replace 2> /dev/null | sed 's/^/export /g')"
fi

export PATH=$PATH:/usr/local/go/bin:~/go/bin
export PATH=$PATH:~/.cargo/bin
alias python=python3
alias sail="vendor/bin/sail"

# Load Angular CLI autocompletion.
source <(ng completion script)
