{
  virtualisation.virtualbox = {
    host = {
      enable = true;
      enableExtensionPack = true;
      enableKvm = true;
      addNetworkInterface = false;
    };
  };
  users.extraGroups.vboxusers.members = [ "tony" ];
  users.extraGroups.vboxsf.members = [ "tony" ];
}
