# fw-al.nix
{
  lib,
  pkgs,
  private,
  ...
}:
{

  imports = [
    ./hardware.nix
    ./disk.nix
    ./schoolpkgs.nix

    ../modules/cli.nix
    ../modules/docker.nix
    ../modules/gnome.nix
    ../modules/ios.nix
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
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [
      ];
    };
    extraHosts = ''
      ${private.ip.git} git.infologin.ch
      ${private.ip.rs} rapport.infologin.ch
      ${private.ip.vlt} vlt.infologin.ch
    '';
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  nixpkgs.config.allowUnfree = true;

  # Enable LVFS testing to get UEFI updates
  services.fwupd.extraRemotes = [ "lvfs-testing" ];

  # Set your time zone.
  time.timeZone = "Europe/Zurich";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.tony = {
    isNormalUser = true;
    description = "";
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
      "libvirt"
      "kvm"
    ];
  };

  fonts.packages = with pkgs; [
    maple-mono.NF
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
