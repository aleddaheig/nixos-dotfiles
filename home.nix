# home.nix
{ config, pkgs, ... }: 
  let
    synology-drive-xcb = pkgs.synology-drive-client.overrideAttrs (prevAttrs: {
      nativeBuildInputs = (prevAttrs.nativeBuildInputs or []) ++ [ pkgs.makeBinaryWrapper ];

      postInstall = (prevAttrs.postInstall or "") + ''
        wrapProgram $out/bin/synology-drive --set QT_QPA_PLATFORM xcb
      '';
    });
  in {

  home.username = "tony";
  home.homeDirectory = "/home/tony";

  home.packages = with pkgs; [
    firefox-wayland
    brave

    zeal
    
    bisq-desktop

    gnome.ghex

    bind

    wineWowPackages.waylandFull

    appimage-run

    pfetch
    neofetch
    
    zip
    xz
    unzip
    p7zip

    file
    tree

    signal-desktop
    telegram-desktop
    vscode
    teams-for-linux
    synology-drive-xcb

    zettlr
    drawing
    gimp
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

  # Enable gnome-keyring - omit gnome-keyring-ssh
  services.gnome-keyring = {
    enable = true;
    components = [ "pkcs11" "secrets" ];
  };

  services.gpg-agent.pinentryPackage = "pkgs.pinentry-gnome3";

  xdg.desktopEntries = {
    zettlr = {
      name = "Zettlr";
      exec = "zettlr --enable-features=UseOzonePlatform --ozone-platform=wayland --no-sandbox %U";
      terminal = false;
      categories = [ "Application" "Office" ];
      mimeType = [ "text/markdown" ];
    }; 
  };

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
