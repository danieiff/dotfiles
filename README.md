## What's in here

 - Neovim config
   - features: **statusline**, **tabline**, **session manager**, **window resize manager**
   - plugin management with git submodule

 - Docker image of this setup
   - GitHub Action for image build

 - minimal Zellij config

 - ZMK keyboard config
   - corne 40% wireless keyboard
   - GitHub Action for firmware build


## Setup

### With your favorite package manager

- `git clone https://github.com/danieiff/dotfiles --filter=blob:none --recurse-submodules=nvim/pack/required --also-filter-submodules=blob:none --jobs 20`

- `curl https://mise.run | sh`
  (Windows: `winget install git.git jdx.mise`)

- `mise use -g zig node neovim@nightly yq ripgrep github-cli fzf`

- `ln -s ~/dotfiles/nvim ${XDG_CONFIG_HOME:-~/.config}`
  (Windows: `New-Item -Path $ENV:LOCALAPPDATA/nvim -ItemType SymbolicLink -Value dotfiles/nvim`)

### Nix home-manager

 1. Install nix home-manager with flake enabled
 2. Run `home-manager --flake "github:danieiff/dotfiles/main?dir=home-manager" switch --impure`

