#!/bin/bash

set -e

sudo apt update && sudo apt install -y curl git tar unzip fzf ripgrep clang

DOTFILES_DIR="$(pwd)/dotfiles"
[ ! -d "$DOTFILES_DIR" ] && git clone --depth 1 https://github.com/danieiff/dotfiles "$DOTFILES_DIR"
cp -fsr "$DOTFILES_DIR" ~/.config && (cp -fs "$DOTFILES_DIR"/.* ~ || true)

curl -L https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz | sudo tar -C /bin -xz

GH_VERSION=$(curl -s https://api.github.com/repos/cli/cli/releases/latest | grep -Po '"tag_name": "v\K[^"]*') && \
  curl -L "https://github.com/cli/cli/releases/latest/download/gh_${GH_VERSION}_linux_amd64.tar.gz" | tar xvz && \
  sudo cp gh_"$GH_VERSION"_linux_amd64/bin/gh /bin

LAZYGIT_VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep -Po '"tag_name": "v\K[^"]*') && \
  curl -L "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" | tar xvz && \
  sudo install lazygit /bin

sudo curl -Lo /bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 && sudo chmod +x /bin/yq

sudo curl -Lo /bin/viu https://github.com/atanunq/viu/releases/latest/download/viu-x86_64-unknown-linux-musl && sudo chmod +x /bin/viu

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash && . ~/.nvm/nvm.sh && nvm install 18

curl -L https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz | tar xz && \
  sudo ln -fs "$(pwd)"/nvim-linux64/bin/nvim /bin/nvim && nvim --headless +'sleep 15 | LoadRequiredFileTypes' +'sleep 60 | quitall'

# if [ -z "$REMOTE_CONTAINER" ]; then
#
# curl -fsSL https://get.docker.com | sh
#
# curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
#
# curl -Lo devpod "https://github.com/loft-sh/devpod/releases/latest/download/devpod-linux-amd64" && install -c -m 0755 devpod /bin && rm -f devpod
#
# fi


if [ "$WSLENV" ]; then

  WslLocalAppData="$(wslpath "$(powershell.exe \$Env:LocalAppData)" | tr -d "\r")"
  powershell.exe "(New-Object System.Net.WebClient).DownloadString(\"https://raw.githubusercontent.com/webinstall/webi-installers/main/nerdfont/install.ps1\") | powershell -command -"
  cp "$DOTFILES_DIR/windows-terminal-settings.json" "$WslLocalAppData/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"
  ln -fs "$WslLocalAppData/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json" "$DOTFILES_DIR/_windows-terminal-settings.json"

  ## SSH https://futurismo.biz/archives/6862/#-nat-
  # sudo apt install -y openssh-server
  ### Run in Powershell as Admin
  # $wsl_ipaddress1 = (wsl hostname -I).split(" ", 2)[0]
  # netsh interface portproxy delete v4tov4 listenaddress=0.0.0.0 listenport=22
  # netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=22 connectaddress=$wsl_ipaddress1 connectport=22
  # netsh interface portproxy show v4tov4
  # Foreach ( $dir in "Inbound","Outbound" ) { New-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' -Direction Outbound -LocalPort 22 -Action Allow -Protocol TCP }

  # vi /etc/ssh/sshd_config # Edit yes/no for PubkeyAuthentication, PasswordAuthentication
  # sudo chmod 600 ~/.ssh/authorized_keys

  # ssh-keygen && ssh-copy-id <user@host>
  # # Opt) Generate public domain e.g.) https://www.noip.com/
  # # Config Wifi router to open port or proxy to different port from default of ssh
  # dev() {
  #   ssh -L "${1:-3000}:localhost:${1:-3000}" <user@host>
  # }
  # sudo systemctl start sshd

  ## Keyring
  sudo apt install -y gnome-keyring

  ## Chrome (google-chrome)
  curl -O https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  set +e
  sudo dpkg -i google-chrome-stable_current_amd64.deb
  sudo apt install language-pack-ja fonts-ipafont fonts-ipaexfont
  set -e
  sudo apt install --fix-broken -y
  fc-cache -fv
fi

source ~/.bashrc
