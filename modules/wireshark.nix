{ pkgs, ... }:
{

  users.extraGroups.wireshark.members = [ "tony" ];
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark-qt;
  };

}
