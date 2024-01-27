# home.nix
{ config, pkgs, ... }: {

  home.username = "tony";
  home.homeDirectory = "/home/tony";

  home.packages = with pkgs; [
    firefox-wayland
    bind
    keepassxc

    pfetch
    neofetch
    
    zip
    xz
    unzip
    p7zip

    file
    tree

    signal-desktop
    jetbrains.clion

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
    };
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    extraConfig = ''
      set expandtab
      set tabstop=2
      set shiftwidth=2
    '';
  };

  home.stateVersion = "23.11";

  programs.home-manager.enable = true;
}
