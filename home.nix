# home.nix
{ config, pkgs, ... }: 
  let
    synology-drive-xcb = pkgs.synology-drive-client.overrideAttrs (prevAttrs: {
      nativeBuildInputs = (prevAttrs.nativeBuildInputs or []) ++ [ pkgs.makeBinaryWrapper ];

      postInstall = (prevAttrs.postInstall or "") + ''
        wrapQtApp $out/bin/synology-drive --set QT_QPA_PLATFORM xcb
      '';
    });
  in {

  home.username = "tony";
  home.homeDirectory = "/home/tony";

  home.packages = with pkgs; [
    brave
    floorp

    localsend

    shotcut

    zeal
    
    gnome.ghex
    papers

    bind

    wineWowPackages.waylandFull

    pfetch
    neofetch
    
    zip
    xz
    unzip
    p7zip

    file
    tree

    yt-dlp

    signal-desktop
    telegram-desktop
    vscodium
    teams-for-linux
    synology-drive-xcb

    drawing
    xournalpp
    logseq
    gImageReader

    btop
    htop

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

  programs.direnv = {
    enable = true;
    enableBashIntegration = true; # see note on other shells below
    nix-direnv.enable = true;
  };

  # Enable gnome-keyring - omit gnome-keyring-ssh
  services.gnome-keyring = {
    enable = true;
    components = [ "pkcs11" "secrets" ];
  };

  services.gpg-agent.pinentryPackage = "pkgs.pinentry-gnome3";

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
