# fw-al.nix
{ config, lib, pkgs, ... }: {

  networking.hostName = "fw-al";

  networking.useDHCP = lib.mkDefault true;

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

  # Enable LVFS testing to get UEFI updates
  services.fwupd.extraRemotes = [ "lvfs-testing" ];

  # Enable fractional scaling
  services.xserver.desktopManager.gnome = {
    extraGSettingsOverrides = ''
      [org.gnome.mutter]
      experimental-features=['scale-monitor-framebuffer']
    '';
    extraGSettingsOverridePackages = [ pkgs.gnome.mutter ];
  };

  services.xserver.displayManager.autoLogin = {
    enable = true;
    user = "tony";
  };

  # Workaround auto-login gnome-shell crash
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tony = {
    isNormalUser = true;
    description = "";
    extraGroups = [ "networkmanager" "wheel" "docker" "wireshark" ];
  };
}
