{
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
