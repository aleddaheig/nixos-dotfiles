{
  # VirtualBox 7.1.8 is currently incompatible with Linux kernel 6.15
  # Disabled until compatibility is fixed in a newer VirtualBox version
  virtualisation.virtualbox = {
    host = {
      enable = true;
      enableExtensionPack = true;
      addNetworkInterface = true;
    };
  };
  users.extraGroups.vboxusers.members = [ "tony" ];
  users.extraGroups.vboxsf.members = [ "tony" ];
}
