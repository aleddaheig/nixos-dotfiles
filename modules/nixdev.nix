{ pkgs, nixpkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    nixfmt-rfc-style
    nixd
  ];

  nix.nixPath = [ "nixpkgs=${nixpkgs}" ];

}
