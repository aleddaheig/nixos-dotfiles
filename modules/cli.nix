{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    appimage-run
    cmake
    gcc
    gdb
    git
    git-crypt
    gnumake
    gnupg
    inetutils
    openfortivpn
  ];
}
