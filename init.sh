#!/bin/bash

sudo apt update && sudo apt upgrade

shelltype="$([ -n "$BASH_VERSION" ] && echo "bash" || echo "zsh")"
ln -s "~/"$(dirname "${BASH_SOURCE[0]}")"/.${shelltype}rc" ~ && source "$HOME/.${shelltype}rc"
ln -s ~/"$(dirname "${BASH_SOURCE[0]}")"/.gitconfig ~

# Node.js
curl -L https://bit.ly/n-install | bash

# NeoVim
output=$(ghinstall "neovim/neovim") && sudo ln -s ~/"$output"/bin/nvim /bin/nvim
ln -s ~/dotfiles/init.lua ~/.config/nvim/init.lua

# WSL
WslLocalAppData="$(wslpath "$(powershell.exe \$Env:LocalAppData)" | tr -d "\r")"
ln -s ~/dotfiles/windows-terminal.json "$WslLocalAppData/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"

## WSL SSH
sudo apt install openssh-server
### Test within local by myself
sudo systemctl start ssh
### Run in Powershell as Admin
# $wsl_ipaddress1 = (wsl hostname -I).split(" ", 2)[0]
# netsh interface portproxy delete v4tov4 listenaddress=0.0.0.0 listenport=22
# netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=22 connectaddress=$wsl_ipaddress1 connectport=22
# netsh interface portproxy show v4tov4
# Foreach ( $dir in "Inbound","Outbound" ) { New-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' -Direction Outbound -LocalPort 22 -Action Allow -Protocol TCP }

chmod 600 ~/.ssh/authorized_keys

# dev() {
#   ssh -L "${1:-3000}:localhost:${1:-3000}" user@host
# }

## Chrome (google-chrome)
sudo wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo apt install --fix-broken -y
sudo dpkg -i google-chrome-stable_current_amd64.deb

sudo apt install fzf
sudo apt install gh
sudo apt install yq
sudo apt install clang

cargo xtask install --server
cargo install ripgrep
cargo install git-delta
cargo install delta
cargo install fd-find
cargo install deno --locked
cargo install bat
cargo install viu
cargo install dotenv-linter

# Firebase
npm i -g firebase-tools && sudo apt install default-jdk
