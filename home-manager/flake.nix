{
  description = "Home Manager configuration managing my dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nixneovimplugins.url = github:NixNeovim/NixNeovimPlugins;


  };

  outputs =
    { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = builtins.currentSystem;
      pkgs = nixpkgs.legacyPackages.${system};
      username = builtins.getEnv "USER";
      homeDirectory  = builtins.getEnv "HOME";
      # overlays = [
      #  inputs.neovim-nightly-overlay.overlays.default
      # ];
    in
    {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [ 
     	  ./home.nix
	  {
	    nixpkgs.overlays = [
              inputs.neovim-nightly-overlay.overlays.default
              inputs.nixneovimplugins.overlays.default
	    ];
	  }
        ];

        # Optionally use extraSpecialArgs to pass through arguments to home.nix
        extraSpecialArgs = {
          username = username;
          homeDirectory = homeDirectory;
	};
      };
    };
}
