#!/bin/bash

set -e

apt update &&  apt install -y curl git tar unzip fzf ripgrep clang

[ ! -d "dotfiles" ] && git clone --depth 1 https://github.com/danieiff/dotfiles
mkdir -p ~/.config && cp -fsr /dotfiles ~/.config && (cp -fs /dotfiles/.* ~  || true)

curl -L https://github.com/zellij-org/zellij/releases/download/v0.38.2/zellij-x86_64-unknown-linux-musl.tar.gz | tar -C /usr/local/bin -xz

GH_VERSION=$(curl -s https://api.github.com/repos/cli/cli/releases/latest | grep -Po '"tag_name": "v\K[^"]*') && \
  curl -L "https://github.com/cli/cli/releases/latest/download/gh_${GH_VERSION}_linux_amd64.tar.gz" | tar xvz && \
   cp gh_"$GH_VERSION"_linux_amd64/bin/gh /bin

LAZYGIT_VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep -Po '"tag_name": "v\K[^"]*') && \
  curl -L "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" | tar xvz && \
   install lazygit /bin

curl -L -o /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 && chmod +x /usr/local/bin/yq

curl -L -o /usr/local/bin/viu https://github.com/atanunq/viu/releases/latest/download/viu && chmod +x /usr/local/bin/viu

# Node.js
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash && source ~/.bashrc && nvm install 18

# NeoVim
curl -L https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz | tar xz && \
  ln -fs ~/nvim-linux64/bin/nvim /usr/bin/nvim && nvim --headless +'sleep 30 | LoadRequiredFileTypes' +'sleep 10 | quitall'


# if [ -z "$REMOTE_CONTAINER" ]; then
#
# curl -fsSL https://get.docker.com |  sh
#
# curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
#
# curl -L -o devpod "https://github.com/loft-sh/devpod/releases/latest/download/devpod-linux-amd64" &&  install -c -m 0755 devpod /usr/local/bin && rm -f devpod
#
# npm i -g devcontainer
#
# fi


if [ "$WSLENV" ]; then
  WslLocalAppData="$(wslpath "$(powershell.exe \$Env:LocalAppData)" | tr -d "\r")"
  ln -fs ~/dotfiles/windows-terminal-settings.json "$WslLocalAppData/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"

  ## SSH https://futurismo.biz/archives/6862/#-nat-
  #  apt install -y openssh-server
  ### Run in Powershell as Admin
  # $wsl_ipaddress1 = (wsl hostname -I).split(" ", 2)[0]
  # netsh interface portproxy delete v4tov4 listenaddress=0.0.0.0 listenport=22
  # netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=22 connectaddress=$wsl_ipaddress1 connectport=22
  # netsh interface portproxy show v4tov4
  # Foreach ( $dir in "Inbound","Outbound" ) { New-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' -Direction Outbound -LocalPort 22 -Action Allow -Protocol TCP }

  #  vi /etc/ssh/sshd_config # Edit yes/no for PubkeyAuthentication, PasswordAuthentication
  # chmod 600 ~/.ssh/authorized_keys

  # ssh-keygen && ssh-copy-id <user@host>
  # # Opt) Generate public domain e.g.) https://www.noip.com/
  # # Config Wifi router to open port or proxy to different port from default of ssh
  # dev() {
  #   ssh -L "${1:-3000}:localhost:${1:-3000}" <user@host>
  # }
  #  systemctl start sshd

  ## Keyring
   apt install -y gnome-keyring

  ## Chrome (google-chrome)
  curl -O https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  set +e
   dpkg -i google-chrome-stable_current_amd64.deb
  set -e
   apt install --fix-broken -y language-pack-ja fonts-ipafont fonts-ipaexfont
  fc-cache -fv

fi
