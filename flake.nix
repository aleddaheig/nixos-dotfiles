{
  description = "My personal flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Secure Boot for NixOS
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # User profile manager based on Nix
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Provides module support for specific vendor hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Nixvim
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      self,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      # Base OS configs
      osModules = [ ./modules/nix.nix ];
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      customPkgs = import ./pkgs {
        inherit nixpkgs;
        pkgs = nixpkgs.legacyPackages.${system};
      };

      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
      private = builtins.fromJSON (builtins.readFile (toString ./.private/private.json));
    in
    {
      formatter.${system} = pkgs.nixfmt-tree;

      nixosConfigurations =
        let
          mkHost =
            hostname:
            nixpkgs.lib.nixosSystem {
              inherit system;
              specialArgs = {
                inherit
                  inputs
                  nixpkgs
                  unstable
                  customPkgs
                  private
                  ;
              };
              modules = osModules ++ [
                # The system configuration
                ./${hostname}

                # Home manager configuration
                home-manager.nixosModules.home-manager
                {
                  home-manager = {
                    extraSpecialArgs = {
                      inherit
                        pkgs
                        unstable
                        inputs
                        self
                        ;
                    };
                    useUserPackages = true;
                    users.tony.imports = [ ./home ];
                  };
                }
              ];
            };
        in
        {
          fw-al = mkHost "fw-al";
        };

    };
}
