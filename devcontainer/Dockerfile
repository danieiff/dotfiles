FROM ubuntu:22.04

RUN useradd -m me
ENV SHELL /bin/bash
ENV HOME /home/me
WORKDIR $HOME
VOLUME $HOME/.config $HOME/.local $HOME/.cache

COPY --from=docker:dind /usr/local/bin/docker /usr/bin/

RUN apt update && apt install -y curl git tar fzf ripgrep clang gosu

RUN GH_VERSION=$(curl -s "https://api.github.com/repos/cli/cli/releases/latest" | grep -Po '"tag_name": "v\K[^"]*') && \
  curl -L https://github.com/cli/cli/releases/latest/download/gh_"$GH_VERSION"_linux_amd64.tar.gz | tar xvz && \
  cp gh_"$GH_VERSION"_linux_amd64/bin/gh /usr/bin/

RUN LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*') && \
  curl -L "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" | tar xvz && \
  install lazygit /usr/bin/

RUN curl -o /usr/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 && \
  chmod +x /usr/bin/yq

RUN curl -L -o /usr/local/bin/viu https://github.com/atanunq/viu/releases/latest/download/viu

RUN curl -fsSL https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz | tar -C /usr/bin/ -xz

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash && \
  export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s ~/.nvm || printf %s "${XDG_CONFIG_HOME}/nvm")" && \
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
  nvm install 18

RUN git clone --depth 1 https://github.com/danieiff/dotfiles; \
  cp -fsr ~/dotfiles ~/.config && (cp -fs ~/dotfiles/.* ~  || true)

RUN curl -fsSL https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz | tar xz && \
  ln -fs ~/nvim-linux64/bin/nvim /usr/bin/ && nvim --headless +'sleep 30 | LoadRequiredFileTypes' +'sleep 10 | quitall'

WORKDIR $HOME/workspace

ENTRYPOINT [ "sh", "-c", "/bin/bash ~/dotfiles/devcontainer/entrypoint.sh zellij" ]
CMD nvim


