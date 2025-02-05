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

    # Quiet boot with plymouth - supports LUKS passphrase entry if needed
    kernelParams = [
      "quiet"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "boot.shell_on_fail"
      "iomem=relaxed"
    ];

    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    consoleLogLevel = 0;
    initrd.verbose = false;
    plymouth.enable = true;
  };

  networking.useDHCP = lib.mkDefault true;

  hardware.enableAllFirmware = true;
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.framework.amd-7040.preventWakeOnAC = true;
  hardware.amdgpu = {
    opencl.enable = true;
    amdvlk = {
      enable = true;
      supportExperimental.enable = true;
    };
  };

  # Enable openGL and install Rocm
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
      rocmPackages.clr
      rocmPackages.rocminfo
      rocmPackages.rocm-runtime
    ];
  };
  # This is necesery because many programs hard-code the path to hip
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

}
