#!/bin/bash

sudo apt update && sudo apt upgrade && \
  sudo apt install -y curl git tar fzf ripgrep gh bat timg clang

shell="${BASH_VERSION:+bash}" || shell="zsh"
ln -fs "~/"$(dirname "${BASH_SOURCE[0]}")"/.${shelltype}rc" ~ && source "$HOME/.${shell}rc"
ln -fs ~/"$(dirname "${BASH_SOURCE[0]}")"/.gitconfig ~

curl -L https://github.com/zellij-org/zellij/releases/download/v0.38.2/zellij-x86_64-unknown-linux-musl.tar.gz | tar -C /usr/local/bin -xz

curl -L -o /usr/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 && chmod +x /usr/bin/yq

# Node.js
curl -fsSL https://raw.githubusercontent.com/tj/n/master/bin/n | bash -s lts && \
  npm install -g n

# NeoVim
curl -L https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz | tar xz && \
  ln -fs /nvim-linux64/bin/nvim /usr/bin/nvim

# Firebase
npm i -g firebase-tools && sudo apt install default-jdk

# WSL
if [ "$WSLENV" ]; then
WslLocalAppData="$(wslpath "$(powershell.exe \$Env:LocalAppData)" | tr -d "\r")"
ln -fs ~/dotfiles/windows-terminal.json "$WslLocalAppData/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"

## SSH https://futurismo.biz/archives/6862/#-nat-
sudo apt install openssh-server
### Run in Powershell as Admin
# $wsl_ipaddress1 = (wsl hostname -I).split(" ", 2)[0]
# netsh interface portproxy delete v4tov4 listenaddress=0.0.0.0 listenport=22
# netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=22 connectaddress=$wsl_ipaddress1 connectport=22
# netsh interface portproxy show v4tov4
# Foreach ( $dir in "Inbound","Outbound" ) { New-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' -Direction Outbound -LocalPort 22 -Action Allow -Protocol TCP }

# sudo vi /etc/ssh/sshd_config # Edit yes/no for PubkeyAuthentication, PasswordAuthentication
chmod 600 ~/.ssh/authorized_keys

# ssh-keygen && ssh-copy-id <user@host>
# # Generate public domain e.g.) https://www.noip.com/
# # Config Wifi router to open port or proxy to different port from default of ssh
# dev() {
#   ssh -L "${1:-3000}:localhost:${1:-3000}" <user@host>
# }

sudo systemctl start sshd

## Chrome (google-chrome)
curl -LO https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo apt install --fix-all -y language-pack-ja fonts-ipafont fonts-ipaexfont
fc-cache -fv
fi
