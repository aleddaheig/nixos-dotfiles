{ ... }:
{
  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = [ "tony" ];
  virtualisation.docker.daemon.settings = {
    data-root = "/home/tony/docker/";
    userland-proxy = false;
    experimental = true;
    ipv6 = false;
  };
}
