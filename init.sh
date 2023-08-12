#!/bin/bash

set -eu
trap 'echo "EXIT detected with exit status $?"' EXIT

# Bash
sudo apt update && apt upgrade 
DOT_FILES=(.bashrc .gitconfig)
for file in ${DOT_FILES[@]}; do ln -s ~/`dirname $0`/$file ~;  done

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install
. ~/.bashrc

# Node.js https://github.com/tj/n#installation
# make cache folder (if missing) and  take ownership
sudo mkdir -p /usr/local/n
sudo chown -R $(whoami) /usr/local/n
# make sure the requried folders exist (safe to execute even if they already exist)
sudo  mkdir -p /usr/local/bin /usr/local/lib /usr/local/include /usr/local/share
# take ownership of Node.js install destination folders
sudo chown -R $(whoami) /usr/local/bin /usr/local/lib /usr/local/include /usr/local/share
curl -fsSL https://raw.githubusercontent.com/tj/n/master/bin/n | bash -s lts

npm install -g n

# NeoVim
output=$(ghinstall "neovim/neovim") && sudo ln -s ~/"$output"/bin/nvim /bin/nvim
ln -s ~/dotfiles/init.lua ~/.config/nvim/init.lua

mkdir -p ~/.config/lsp/lua && cd "$_"
ghinstall LuaLS/lua-language-server
echo 'export PATH=$PATH:~/.config/lsp/lua/bin' >> ~/.bashrc
npm i -g bash-language-server
npm i -g typescript typescript-language-server
npm i -g vscode-langservers-extracted
npm i -g @tailwindcss/language-server
## TODO: https://github.com/redhat-developer/yaml-language-server

# WSL
 sudo apt install wslu
 printf '[boot]\nsystemd = true\n[interop]\nappendWindowsPath = false\n' | sudo tee /etc/wsl.conf # Reloading WSL takes >8 sec after terminates
 printf 'export PATH=$PATH:$(wslpath "$(wslvar USERPROFILE)")/AppData/Local/Microsoft\ VS\ Code/bin:\n' >> .bashrc # VSCode 'code' command  
 cp dotfiles/windows-terminal.json /mnt/c/User/UserName/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json

## WSL SSH
sudo apt install openssh-server
### For test in localhost
sudo service ssh status # requires '[boot] systemd = true' in '/etc/wsl.conf
ssh-keygen
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
ssh <user>@localhost
### For remote client (Run these on powershell as admin)
# $wsl_ipaddress1 = (wsl -d "Ubuntu" hostname -I).split(" ", 2)[0]
# netsh interface portproxy delete v4tov4 listenaddress=0.0.0.0 listenport=22
# netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=22 connectaddress=$wsl_ipaddress1 connectport=22
# netsh interface portproxy show v4tov4
# New-NetFireWallRule -DisplayName 'WSL Expo ports for LAN development' -Direction 'Inbound' -LocalPort 19000-19002 -Action Allow -Protocol TCP } # ssh <user>@<windows ip addr> from remote client
### For host windows-shells of wsl
# ssh <user>@<wsl ip addr> (after ssh key setup)
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys


# Firebase
npm i -g firebase-tools
sudo apt install default-jdk

# Rust
git clone --depth 1 https://github.com/simrat39/rust-tools.nvim
git clone https://github.com/rust-lang/rust-analyzer.git && cd rust-analyzer
cargo xtask install --server
cargo install ripgrep
cargo install git-delta
cargo install fd-find
cargo install deno --locked
cargo install bat

sudo apt install gh
sudo apt install yq

echo "\nDone."
