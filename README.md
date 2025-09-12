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


## Setup with Nix home-manager

 1. Install nix home-manager with flake enabled
 2. Run `home-manager --flake "github:danieiff/dotfiles/main?dir=home-manager" switch --impure`
