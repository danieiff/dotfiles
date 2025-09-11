{ inputs, config, pkgs, username, homeDirectory, ... }:

{
  home.username = username;
  home.homeDirectory = homeDirectory;

  nixpkgs.config.allowUnfree = true; # Allow installing unfree Licensed software

  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    nerd-fonts.hack

    google-chrome
    slack

    git
    gh
    ripgrep
    fzf
    viu
    jq
    zellij
    neovim
    colima
    docker
    zig

    # You can also create simple shell scripts directly inside your
    # configuration. For example, this adds a command 'my-hello' to your environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];
 
  # Develop neovim-nightly: nix develop "github:nix-community/neovim-nightly-overlay"
  programs.neovim = {
    enable = true;
    defaultEditor = true;

    # https://github.com/NixNeovim/NixNeovimPlugins
    plugins = with pkgs.vimPlugins; [
      plenary-nvim
      nvim-nio
      nui-nvim
      nvim-web-devicons
      vscode-nvim
      nightfox-nvim

      nvim-treesitter
      nvim-treesitter-context
      vim-illuminate
      indent-blankline-nvim
      satellite-nvim
      aerial-nvim
      nvim-tree-lua
      csvview-nvim

      nvim-autopairs
      nvim-ts-autotag
      nvim-scissors
      nvim-surround
      refactoring-nvim
      fzf-lua
      trouble-nvim
      grug-far-nvim
      leap-nvim
      overseer-nvim
      iron-nvim
      kulala-nvim

      blink-cmp
      friendly-snippets
      neogen
      windsurf-nvim
      avante-nvim

      neogit
      gitsigns-nvim
      diffview-nvim
      octo-nvim

      nvim-lint
      conform-nvim
      mason-nvim
      nvim-lspconfig
      symbol-usage-nvim
      nvim-dap-ui
      nvim-dap
      nvim-dap-virtual-text
      neotest

      pkgs.vimExtraPlugins.aoc-nvim
      # JavaScript
      typescript-tools-nvim
      pkgs.vimExtraPlugins.nvim-dap-ruby
      neotest-jest
      # Rust
      crates-nvim
      rustaceanvim
      neotest-rust
      # misc
      roslyn-nvim
      nvim-dbee
      go-nvim
    ];

    extraPackages = with pkgs; [
      # Nix
      nil
      nixfmt-rfc-style
      # Lua
      lua-language-server
      stylua
      # Node
      nodePackages.typescript-language-server
      # Misc
      bash-language-server
      vim-language-server
      emmet-language-server
      pyright
      gopls
    ];
  };

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/dotfiles/nvim";
  };

  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/${username}/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
