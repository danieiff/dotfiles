#!/bin/bash
# curl https://raw.githubusercontent.com/danieiff/dotfiles/setup | sh

set -e && cd ~

sudo apt update && sudo apt install -y

[ -d dotfiles ] || git clone --depth 1 https://github.com/danieiff/dotfiles
cp -fsr dotfiles/nvim ~/.config

curl https://mise.run | sh
mise use -g zig node zellij neovim yq ripgrep github-cli 

nvim --headless +'sleep 15 | LoadRequiredFileTypes' +'sleep 60 | quitall'

ulimit -n 10240

# if [ -z "$REMOTE_CONTAINER" ]; then
# curl -fsSL https://get.docker.com | sh
# curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
# curl -Lo devpod "https://github.com/loft-sh/devpod/releases/latest/download/devpod-linux-amd64" && install -c -m 0755 devpod /bin && rm -f devpod
# fi

if [ "$WSLENV" ]; then
  WslLocalAppData="$(wslpath "$(powershell.exe \$Env:LocalAppData)" | tr -d "\r")"
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
