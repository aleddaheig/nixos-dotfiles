# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.enableAllFirmware = true;

  # Luks
  boot.initrd.luks.devices = {
    crypted = {
      device = "/dev/disk/by-uuid/70d42b03-de35-4d50-ae1e-f74a4f703dce";
      preLVM = true;
    };
  };

  # Enable networking
  networking.hostName = "fw-al";
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Zurich";
  i18n.defaultLocale = "en_US.utf8";

  # Enable the GNOME Desktop Environment with wayland.
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    displayManager.gdm.wayland = true;
    desktopManager.gnome.enable = true;
    layout = "us";
    xkbVariant = "";
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tony = {
    isNormalUser = true;
    description = "";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      firefox-wayland
      bind
      keepassxc
      git
      pfetch
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    appimage-run
    neovim
    gcc
    gnupg
    pinentry-gnome
    sbctl
    tpm2-tss
    git
    gnome.gnome-tweaks
    gnome.gpaste
    gnomeExtensions.night-theme-switcher
  ];

  fonts.packages = with pkgs; [
    ibm-plex
    merriweather
    noto-fonts
    noto-fonts-emoji
  ];

  # Add env vars
  environment.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    NIXOS_OZONE_WL = "1";
  };

  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  services.gnome.gnome-keyring.enable = lib.mkForce false;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };

  # Updating Firmware
  services.fwupd.enable = true;

  nix.settings.auto-optimise-store = true;
  nix.settings.experimental-features = "nix-command flakes";

  system.stateVersion = "23.11";

}
