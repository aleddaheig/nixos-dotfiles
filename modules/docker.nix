{ config, lib, pkgs, ... }:
{
  virtualisation.docker.enable = true;

  virtualisation.docker.daemon.settings = {
    data-root = "/home/tony/docker/";
    userland-proxy = false;
    experimental = true;
    ipv6 = false;
  };
}
