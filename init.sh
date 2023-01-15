#!/bin/sh;

# DOT_FILES=(.bashrc .vimrc .gitconfig)
# for file in ${DOT_FILES[@]}
# do 
#   ln -s $HOME/`dirname $0`/$file $HOME/$file
# done

# Node.js
# https://github.com/tj/n#installation
# make cache folder *if missing( and  take owner ship
#sudo mkdir -p /usr/local/n
#sudo chown -R $(whoami) /usr/local/n
#make sure the requried folders exist *safe to execute even if they already exist(
#sudo  mkdir -p /usr/local/bin /usr/local/lib /usr/local/include /usr/local/share
# take ownership of Node.js install destination folders
#sudo chown -R $(whoami) /usr/local/bin /usr/local/lib /usr/local/include /usr/local/share
#curl -fsSL https://raw.githubusercontent.com/tj/n/master/bin/n | bash -s lts
#npm install -g n

# Bash
# git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
# ~/.fzf/install

# Vim
# sudo add-apt-repository ppa:jonathonf/vim # For version 9
# sudo apt install vim

# cd ~/.vim/pack/my/start
# git clone https://github.com/prabirshrestha/vim-lsp 
# git clone https://github.com/mattn/vim-lsp-settings
# git clone https://github.com/prabirshrestha/asyncomplete.vim 

# git clone https://github.com/prettier/vim-prettier

# git clone https://github.com/prabirshrestha/asyncomplete-lsp.vim 
# git clone https://github.com/github/copilot.vim ~/.vim/pack/my/start/copilot.vim
# curl https://raw.githubusercontent.com/tomasiser/vim-code-dark/master/colors/codedark.vim --create-dirs -o ~/.vim/colors/codedark.vim

# NeoVim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
sudo mv squashfs-root /
# sudo ln -s /squashfs-root/AppRun /usr/bin/nvim
# ./nvim.appimage --appimage-extract
# ./squashfs-root/AppRun --version
# sudo mv squashfs-root /
# sudo ln -s /squashfs-root/AppRun /usr/bin/nvim

# WSL
# sudo apt install wslu
# printf '[interop]\nappendWindowsPath = false\n' >> /etc/wsl.conf # Reloading WSL takes >8 sec after terminates 
# printf 'export PATH=$PATH:$(wslpath "$(wslvar USERPROFILE)")/AppData/Local/Microsoft\ VS\ Code/bin:\n' >> .bashrc
