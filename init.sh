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
wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
tar xzvf nvim-linux64.tar.gz
ln -s ~/dotfiles/init.lua ~/.config/nvim/init.lua

mkdir -p ~/.config/nvim/pack/my/start && cd "$_"

neovim_plugins=(

  "https://github.com/github/copilot.vim"
  "https://github.com/ggandor/leap.nvim"
  "https://github.com/EdenEast/nightfox.nvim"
  "https://github.com/NvChad/nvim-colorizer.lua"
  
  "https://github.com/nvim-lua/plenary.nvim"
  "https://github.com/nvim-telescope/telescope.nvim"
  "https://github.com/debugloop/telescope-undo.nvim"
  "https://github.com/ibhagwan/fzf-lua"
  "https://github.com/nvim-tree/nvim-tree.lua"
  
  "https://github.com/nvim-treesitter/nvim-treesitter"
  "https://github.com/nvim-treesitter/nvim-treesitter-textobjects"
  "https://github.com/numToStr/Comment.nvim"
  "https://github.com/JoosepAlviste/nvim-ts-context-commentstring"
  "https://github.com/simrat39/symbols-outline.nvim"
  "https://github.com/lukas-reineke/indent-blankline.nvim"
  "https://github.com/kylechui/nvim-surround"
  "https://github.com/danieiff/nvim-ts-autotag"
 
  "https://github.com/windwp/nvim-autopairs"

  "https://github.com/neovim/nvim-lspconfig"
  "https://github.com/hrsh7th/nvim-cmp"
  "https://github.com/hrsh7th/cmp-nvim-lsp"
  "https://github.com/jose-elias-alvarez/null-ls.nvim"

  "https://github.com/lewis6991/gitsigns.nvim"
  "https://github.com/mfussenegger/nvim-dap"
)

for repo in "${neovim_plugins[@]}"; do git clone --depth 1 "$repo"; done

curl -vLJO -H 'Accept: application/octet-stream' https://api.github.com/repos/
mkdir -p ~/.config/lsp/lua && cd "$_"
sumneko/lua-language-server/releases/assets/86357324
tar -xvf <lua-language-server.tar.gz>
echo 'export PATH=$PATH:~/.config/lsp/lua/bin' >> ~/.bashrc
npm i -g bash-language-server
npm i -g typescript typescript-language-server
npm i -g vscode-langservers-extracted
npm i -g @tailwindcss/language-server

# WSL
 sudo apt install wslu
 printf '[interop]\nappendWindowsPath = false\n' | sudo tee /etc/wsl.conf # Reloading WSL takes >8 sec after terminates 
 printf 'export PATH=$PATH:$(wslpath "$(wslvar USERPROFILE)")/AppData/Local/Microsoft\ VS\ Code/bin:\n' >> .bashrc # VSCode 'code' command  
 cp dotfiles/windows-terminal.json /mnt/c/User/UserName/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json

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

sudo apt install gh

echo "\nDone."
