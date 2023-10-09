FROM ubuntu:20.04

RUN apt update && \
  apt-get update && \
  apt install -y curl git tar unzip fzf gh yq clang

RUN apt install -y locales && \
  locale-gen ja_JP.UTF-8

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash && \
  nvim use 18
RUN curl -fsSL https://raw.githubusercontent.com/tj/n/master/bin/n | bash -s lts && \
  npm install -g n

RUN curl -L https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz | tar xz && \
  ln -fs /nvim-linux64/bin/nvim /usr/bin/nvim

RUN git clone --depth 1 https://github.com/danieiff/dotfiles

RUN ln -fs /dotfiles/.bashrc ~/.bashrc && \
  mkdir -p ~/.config/nvim/lua && \
  ln -fs /dotfiles/nvim/init.lua ~/.config/nvim && \
  ln -fs /dotfiles/nvim/lua/* ~/.config/nvim/lua

