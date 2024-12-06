{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [ inputs.nixos-hardware.nixosModules.framework-13-7040-amd ];

  boot = {

    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };

      efi.canTouchEfiVariables = true;

    };

    initrd = {
      # Start systemd on early stage
      systemd.enable = true;
      systemd.tpm2.enable = false;

      availableKernelModules = [
        "xhci_pci"
        "thunderbolt"
        "nvme"
        "usb_storage"
        "sd_mod"
      ];
      kernelModules = [
        "dm-snapshot"
        "tpm_crb"
      ];
    };

    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
  };

  networking.useDHCP = lib.mkDefault true;

  hardware.enableAllFirmware = true;
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.framework.amd-7040.preventWakeOnAC = true;
}
