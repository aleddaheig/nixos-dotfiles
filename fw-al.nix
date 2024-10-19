# fw-al.nix
{ config, lib, pkgs, ... }: {

  # Networking
  networking = {
    hostName = "fw-al";
    useDHCP = lib.mkDefault true;
    firewall = {
       enable = true;
       allowedTCPPorts = [ 80 443 53317 ]; # 53317 is for LocalSend
       allowedUDPPortRanges = [
         { from = 4000; to = 4007; }
         { from = 53315; to = 53318; }
         { from = 8000; to = 8010; }
       ];
     };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.enableAllFirmware = true;

  # Start systemd on early stage
  boot.initrd.systemd.enable = true;
  boot.initrd.systemd.enableTpm2 = false;

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" "tpm_crb" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  # Luks
  boot.initrd.luks.devices."crypted" = {
      device = "/dev/disk/by-uuid/70d42b03-de35-4d50-ae1e-f74a4f703dce";
      preLVM = true;
  };

  fileSystems."/" = {
      device = "/dev/disk/by-uuid/7bc9f6d1-0a7d-4d44-82e6-b7e5b4ccf83d";
      fsType = "ext4";
  };

  fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/5981-0995";
      fsType = "vfat";
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/15ad9535-b26a-485e-9ca9-943d773ebbc5"; }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable LVFS testing to get UEFI updates
  services.fwupd.extraRemotes = [ "lvfs-testing" ];

  # Set your time zone.
  time.timeZone = "Europe/Zurich";
  i18n.defaultLocale = "en_US.utf8";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tony = {
    isNormalUser = true;
    description = "";
    extraGroups = [ "networkmanager" "wheel" "docker" "wireshark" ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
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
