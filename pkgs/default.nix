{ pkgs, nixpkgs }:
let
  inherit (pkgs) callPackage;
in
{
  # windsurf = callPackage ./windsurf {
  #   inputs = {
  #     inherit nixpkgs;
  #   };
  # };
}
