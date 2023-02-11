#!/bin/sh

# Bash
# sudo apt update && apt upgrade 
# DOT_FILES=(.bashrc .gitconfig)
# for file in ${DOT_FILES[@]}; do ln -s ~/`dirname $0`/$file ~;  done
#
# git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
# ~/.fzf/install
# . .bashrc

# Node.js
# https://github.com/tj/n#installation
# make cache folder (if missing) and  take ownership
# sudo mkdir -p /usr/local/n
# sudo chown -R $(whoami) /usr/local/n
# make sure the requried folders exist (safe to execute even if they already exist)
# sudo  mkdir -p /usr/local/bin /usr/local/lib /usr/local/include /usr/local/share
# take ownership of Node.js install destination folders
# sudo chown -R $(whoami) /usr/local/bin /usr/local/lib /usr/local/include /usr/local/share
# curl -fsSL https://raw.githubusercontent.com/tj/n/master/bin/n | bash -s lts
#
# npm install -g n

# NeoVim
# wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
# tar xzvf nvim-linux64.tar.gz
# ln -s ~/dotfiles/init.lua ~/.config/nvim/init.lua
#
mkdir -p ~/.config/nvim/pack/my/start && cd "$_"
# git clone https://github.com/github/copilot.vim # ':Copilot setup'
# git clone --depth 1 https://github.com/ggandor/leap.nvim
# git clone --depth 1 https://github.com/EdenEast/nightfox.nvim
# git clone --depth 1 https://github.com/NvChad/nvim-colorizer.lua
#
# git clone --depht 1 https://github.com/nvim-lua/plenary.nvim
# git clone --depth 1 https://github.com/nvim-telescope/telescope.nvim
#
# git clone --depth 1 https://github.com/nvim-treesitter/nvim-treesitter
# git clone --depth 1 https://github.com/nvim-treesitter/nvim-treesitter-refactor
# git clone --depth 1 https://github.com/numToStr/Comment.nvim
# git clone --depth 1 https://github.com/JoosepAlviste/nvim-ts-context-commentstring
# git clone --depth 1 https://github.com/simrat39/symbols-outline.nvim
# git clone --depth 1 https://github.com/lukas-reineke/indent-blankline.nvim
# git clone --depth 1 https://github.com/kylechui/nvim-surround
#
#
# git clone https://github.com/neovim/nvim-lspconfig
# curl -vLJO -H 'Accept: application/octet-stream' https://api.github.com/repos/
# mkdir -p ~/.config/lsp/lua && cd "$_"
# sumneko/lua-language-server/releases/assets/86357324
# tar -xvf <lua-language-server.tar.gz>
# echo 'export PATH=$PATH:~/.config/lsp/lua/bin' >> ~/.bashrc
# npm i -g bash-language-server
# npm i -g typescript typescript-language-server
# npm i -g @tailwindcss/language-server
#
# git clone --depth 1 https://github.com/lewis6991/gitsigns.nvim

# Vim
# sudo add-apt-repository ppa:jonathonf/vim # For version 9
# sudo apt install vim
#
# mkdir -p ~/.vim/pack/my/start && cd "$_"
# git clone https://github.com/prabirshrestha/vim-lsp 
# git clone https://github.com/mattn/vim-lsp-settings
# git clone https://github.com/prabirshrestha/asyncomplete.vim 
#
# git clone https://github.com/prettier/vim-prettier
#
# git clone https://github.com/prabirshrestha/asyncomplete-lsp.vim 
# git clone https://github.com/github/copilot.vim ~/.vim/pack/my/start/copilot.vim
# curl https://raw.githubusercontent.com/tomasiser/vim-code-dark/master/colors/codedark.vim --create-dirs -o ~/.vim/colors/codedark.vim
# ln -s ~/`dirname $0`/.vimrc ~/.vimrc

# sudo apt install g--h

# WSL
# sudo apt install w--slu
# printf '[interop]\--nappendWindowsPath = false\n' | sudo tee /etc/wsl.conf # Reloading WSL takes >8 sec after terminates 
# printf 'export PAT--H=$PATH:$(wslpath "$(wslvar USERPROFILE)")/AppData/Local/Microsoft\ VS\ Code/bin:\n' >> .bashrc # VSCode 'code' command  

# Firebase
# npm i -g firebase-tools
# sudo apt install default-jdk
