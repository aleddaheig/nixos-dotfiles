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

    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      # Base OS configs
      osModules = [
        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.nixos-hardware.nixosModules.framework-13-7040-amd
        ./modules/docker.nix
        ./modules/gui.nix
        ./modules/nix.nix
        ./modules/printing.nix
        ./modules/secure-boot.nix
        ./modules/virtualbox.nix
      ];
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        config.permittedInsecurePackages = [ "electron-27.3.11" ];
      };
      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {

      nixosConfigurations = {

        fw-al = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = osModules ++ [
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = {
                  inherit pkgs;
                  inherit unstable;
                };
                useUserPackages = true;
                users.tony = import ./home;
              };
            }
            ./fw-al
          ];
          specialArgs = {
            inherit inputs;
          };
        };

      };
    };
}
