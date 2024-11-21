# home.nix
{ pkgs, unstable, ... }:
{

  imports = [
    ./modules/fhs.nix
    ./modules/logseq.nix
    ./modules/nixdev.nix
    ./modules/nixvim
    ./modules/pandoc.nix
  ];

  home.username = "tony";
  home.homeDirectory = "/home/tony";

  home.packages =
    with pkgs;
    [
      bind
      brave
      btop
      file
      floorp
      focuswriter
      gImageReader
      htop
      hunspellDicts.fr-any
      imagemagick
      mumble
      neofetch
      nmap
      p7zip
      pciutils
      pdfarranger
      pfetch
      remmina
      signal-desktop
      telegram-desktop
      tree
      unzip
      usbutils
      vscodium.fhs
      xz
      yt-dlp
      zip
    ]
    ++ (with unstable; [ synology-drive-client ]);

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
      alias gc="sudo nix-collect-garbage --delete-old"
      alias logisim="java -jar ~/Dev/java/SYL/logisim-evolution.t.jar &"
    '';

    shellAliases = { };
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
