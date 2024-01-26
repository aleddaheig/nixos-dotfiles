{ config, pkgs, ... }:

{
  home.username = "tony";
  home.homeDirectory = "/home/tony";

  home.packages = with pkgs; [
    neofetch
    zip
    xz
    unzip
    p7zip

    file
    tree

    signal-desktop

    btop

    pciutils
    usbutils
  ];

  programs.git = {
    enable = true;
    userName = "Anthony Ledda";
    userEmail = "anthony.ledda@heig-vd.ch";
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;

    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    '';

    shellAliases = {
      vim = "nvim";
    };
  };

  home.stateVersion = "23.11";

  programs.home-manager.enable = true;
}
