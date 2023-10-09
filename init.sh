#!/bin/bash

sudo apt update && sudo apt upgrade

shelltype="$([ -n "$BASH_VERSION" ] && echo "bash" || echo "zsh")"
ln -fs "~/"$(dirname "${BASH_SOURCE[0]}")"/.${shelltype}rc" ~ && source "$HOME/.${shelltype}rc"
ln -fs ~/"$(dirname "${BASH_SOURCE[0]}")"/.gitconfig ~

# Node.js
curl -L https://bit.ly/n-install | bash

# NeoVim
curl -L https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz | tar xz
ln -fs ~/nvim-linux64/bin/nvim /usr/bin/nvim
mkdir -p ~/.config/nvim/lua
ln -fs ~/dotfiles/init.lua ~/.config/nvim
ln -fs ~/dotfiles/lua/* ~/.config/nvim/lua

# WSL
WslLocalAppData="$(wslpath "$(powershell.exe \$Env:LocalAppData)" | tr -d "\r")"
ln -s ~/dotfiles/windows-terminal.json "$WslLocalAppData/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"

## WSL SSH
sudo apt install openssh-server
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
wget curl -LO https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo apt install --fix-broken -y

sudo apt install fzf gh yq clang

cargo install ripgrep delta fd-find bat viu dotenv-linter

# Firebase
npm i -g firebase-tools && sudo apt install default-jdk
