{ ... }:
{
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

  swapDevices = [ { device = "/dev/disk/by-uuid/15ad9535-b26a-485e-9ca9-943d773ebbc5"; } ];
}
