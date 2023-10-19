FROM ubuntu:22.04

RUN apt update && \
  apt install -y curl git tar fzf ripgrep gh bat timg build-essential gosu

RUN apt install -y locales && \
  locale-gen ja_JP.UTF-8

RUN curl -o /usr/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 && \
  chmod +x /usr/bin/yq

RUN curl -fsSL https://github.com/sharkdp/fd/releases/download/v8.7.0/fd-v8.7.0-x86_64-unknown-linux-gnu.tar.gz | tar -xz && cp fd-v8.7.0-x86_64-unknown-linux-gnu/fd /usr/bin

RUN curl -fsSL https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz | tar -C /usr/bin -xz

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash && \
  export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")" && \
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
  nvm install 18

RUN curl -fsSL https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz | tar xz && \
  ln -fs /nvim-linux64/bin/nvim /usr/bin/nvim

RUN git clone --depth 1 https://github.com/danieiff/dotfiles && \
  cp -rs /dotfiles ~/.config && cp -f /dotfiles/.* ~ || true

RUN nvim +:q

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
