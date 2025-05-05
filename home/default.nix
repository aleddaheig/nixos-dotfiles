# home.nix
{
  inputs,
  pkgs,
  unstable,
  lib,
  ...
}:
{

  imports = [
    ./modules/fhs.nix
    ./modules/logseq.nix
    ./modules/nixdev.nix
    ./modules/nixvim
    ./modules/pandoc.nix
    ./modules/vscodium.nix
  ];

  home.username = "tony";
  home.homeDirectory = "/home/tony";

  home.packages =
    (with pkgs; [
      bind
      brave
      btop
      cookiecutter
      file
      floorp
      gImageReader
      htop
      hunspellDicts.fr-any
      imagemagick
      neofetch
      nmap
      nvtopPackages.amd
      p7zip
      pciutils
      pdfarranger
      pfetch
      remmina
      signal-desktop
      synology-drive-client
      telegram-desktop
      tree
      unzip
      usbutils
      xz
      yt-dlp
      zip
    ])
    ++ (with inputs; [
      ghostty.packages.x86_64-linux.default
    ]);

  home.sessionVariables = {
    PATH = lib.mkDefault "$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin:$HOME/.local/share/JetBrains/Toolbox/scripts";
    VSCODE_GALLERY_SERVICE_URL = lib.mkDefault "https://marketplace.visualstudio.com/_apis/public/gallery";
    VSCODE_GALLERY_ITEM_URL = lib.mkDefault "https://marketplace.visualstudio.com/items";
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "Anthony Ledda";
    userEmail = "anthony.ledda@heig-vd.ch";
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;

    bashrcExtra = ''
      alias sail='[ -f sail ] && sh sail || sh vendor/bin/sail'
      alias tnc="nc -zv"
      alias gc="sudo nix-collect-garbage --delete-old"
      alias n-file="nix-locate --top-level --whole-name --minimal"
    '';

    shellAliases = { };
  };

  programs.nix-index = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true; # see note on other shells below
    nix-direnv.enable = true;
  };

  # Enable gnome-keyring - omit gnome-keyring-ssh
  services.gnome-keyring = {
    enable = true;
    components = [
      "pkcs11"
      "secrets"
    ];
  };

  services.gpg-agent.pinentryPackage = "pkgs.pinentry-gnome3";

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
