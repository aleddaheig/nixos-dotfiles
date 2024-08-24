# system.nix
# Main system configuration
{ config, lib, pkgs, ... }: {

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.kernelPackages = pkgs.linuxPackages_6_8;
  hardware.enableAllFirmware = true;

  # Enable networking
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
    # Workaround for Gnome-control-center missing schema
    desktopManager.gnome.sessionPath = [ pkgs.gnome.gpaste ];
    xkb = {
      layout = "us";
      variant = "";
    };
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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    corefonts
    appimage-run
    neovim
    inetutils
    wireshark-qt
    gcc
    gdb
    cmake
    gnumake
    gnupg
    python3
    pinentry-gnome3
    sbctl
    tpm2-tss
    git
    gnome.gnome-tweaks
    gnome.gpaste
    gnomeExtensions.night-theme-switcher
    gnomeExtensions.appindicator
    gnomeExtensions.dash-to-dock
    gnomeExtensions.blur-my-shell
    gnome.networkmanager-openconnect
    globalprotect-openconnect
  ];

  environment.gnome.excludePackages = [  pkgs.epiphany ];

  fonts.packages = with pkgs; [
    ibm-plex
    merriweather
    noto-fonts
    noto-fonts-emoji
  ];

  # Add env vars
  environment.sessionVariables = {
    QT_QPA_PLATFORM = "wayland;xcb";
    NIXOS_OZONE_WL = "1";
  };

  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark-qt;
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
  nix.settings.substituters = [ "https://nix-community.cachix.org" "https://cache.nixos.org/" ];
  nix.settings.trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];

  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  users.extraGroups.vboxusers.members = [ "tony" ];

  system.stateVersion = "24.05";
}
