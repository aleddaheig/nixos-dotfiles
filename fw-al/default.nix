# fw-al.nix
{ lib, pkgs, ... }:
{

  imports = [
    ./hardware.nix
    ./disk.nix
    ./schoolpkgs.nix

    ../modules/cli.nix
    ../modules/docker.nix
    ../modules/gnome.nix
    ../modules/kdePackages.nix
    ../modules/localsend.nix
    ../modules/ollama.nix
    ../modules/printing.nix
    ../modules/secure-boot.nix
    ../modules/ssh.nix
    ../modules/virtualbox.nix
    ../modules/wireshark.nix
  ];

  # Networking
  networking = {
    hostName = "fw-al";
    networkmanager = {
      enable = true;
      enableStrongSwan = true;
      plugins = [
        pkgs.networkmanager-l2tp
        pkgs.networkmanager_strongswan
      ];
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [
        5656
        3000
      ];
    };
    extraHosts = ''
      172.16.159.38 git.infologin.ch
    '';
  };

  services.strongswan = {
    enable = true;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  nixpkgs.config.allowUnfree = true;

  # Enable LVFS testing to get UEFI updates
  services.fwupd.extraRemotes = [ "lvfs-testing" ];

  # Set your time zone.
  time.timeZone = "Europe/Zurich";
  i18n.defaultLocale = "en_US.utf8";

  users.users.tony = {
    isNormalUser = true;
    description = "";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  fonts.packages = with pkgs; [
    maple-mono
    corefonts
    ibm-plex
    merriweather
    noto-fonts
    noto-fonts-emoji
  ];

  #systemd.enableStrictShellChecks = true;

  # Updating Firmware
  services.fwupd.enable = true;

  system.stateVersion = "24.05";
}
