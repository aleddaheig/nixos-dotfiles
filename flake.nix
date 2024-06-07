{
  description = "My personal flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    # Secure Boot for NixOS
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # User profile manager based on Nix
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Provides module support for specific vendor hardware 
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      # Base OS configs
      osModules = [
        inputs.lanzaboote.nixosModules.lanzaboote
        ./secure-boot.nix
        ./system.nix
      ];

    in {
      nixosConfigurations = {

        fw-al = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = osModules ++ [
            inputs.home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.tony = import ./home.nix;
            }
            inputs.nixos-hardware.nixosModules.framework-13-7040-amd
            ./fw-al.nix
          ];
        };

      };
    };
}
