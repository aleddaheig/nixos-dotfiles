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
    bind

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
    jetbrains.clion
    teams-for-linux
    synology-drive-xcb

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

  # Enable gnome-keyring - omit gnome-keyring-ssh
  services.gnome-keyring = {
    enable = true;
    components = [ "pkcs11" "secrets" ];
  };

  services.gpg-agent.pinentryFlavor = "gnome3";

  home.stateVersion = "23.11";

  programs.home-manager.enable = true;
}
