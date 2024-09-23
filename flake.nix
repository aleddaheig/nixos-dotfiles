{
  description = "My personal flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

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

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }@inputs:
    let
      system = "x86_64-linux";
      # Base OS configs
      osModules = [
        inputs.lanzaboote.nixosModules.lanzaboote
        ./modules/secure-boot.nix
        ./modules/gui.nix
        ./modules/docker.nix
        ./modules/fhs.nix
      ];
      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in {

      nixosConfigurations = {

        fw-al = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = osModules ++ [
            inputs.home-manager.nixosModules.home-manager {
              home-manager.extraSpecialArgs = { inherit unstable; };
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
