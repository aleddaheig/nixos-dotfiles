# home.nix
{ config, inputs, pkgs, unstable, ... }: 
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
    bind
    brave
    btop
    drawing
    evince
    file
    floorp
    gImageReader
    gnome.ghex
    htop
    localsend
    mumble
    neofetch
    p7zip
    pciutils
    pfetch
    shotcut
    signal-desktop
    synology-drive-xcb
    teams-for-linux
    telegram-desktop
    tree
    unzip
    usbutils
    vscodium.fhs
    xournalpp
    xz
    yt-dlp
    zeal
    zip

    unstable.logseq
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

      alias tnc="nc -zv"
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
