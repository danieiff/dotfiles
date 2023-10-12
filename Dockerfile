FROM ubuntu:22.04

RUN apt update && \
  apt install -y curl git tar fzf ripgrep gh bat timg build-essential

RUN apt install -y locales && \
  locale-gen ja_JP.UTF-8

RUN curl -o /usr/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 && \
  chmod +x /usr/bin/yq

RUN curl -fsSL https://github.com/sharkdp/fd/releases/download/v8.7.0/fd-v8.7.0-x86_64-unknown-linux-gnu.tar.gz | tar -xz && cp fd-v8.7.0-x86_64-unknown-linux-gnu/fd /usr/bin

RUN curl -fsSL https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz | tar -C /usr/bin -xz

RUN curl -fsSL https://raw.githubusercontent.com/tj/n/master/bin/n | bash -s lts && \
  npm install -g n

RUN curl -fsSL https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz | tar xz && \
  ln -fs /nvim-linux64/bin/nvim /usr/bin/nvim

RUN git clone --depth 1 https://github.com/danieiff/dotfiles

RUN ln -fs /dotfiles/.bashrc ~/.bashrc && \
  mkdir -p ~/.config/nvim/lua && \
  ln -fs /dotfiles/nvim/init.lua ~/.config/nvim && \
  ln -fs /dotfiles/nvim/lua/* ~/.config/nvim/lua
