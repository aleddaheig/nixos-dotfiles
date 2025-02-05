{ inputs, pkgs, ... }:
{
  config.environment.systemPackages = [
    inputs.ghostty.packages.x86_64-linux.default
    pkgs.nautilus-open-any-terminal
  ];

  config.programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "ghostty";
  };
}
