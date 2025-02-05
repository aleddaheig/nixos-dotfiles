{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    appimage-run
    cmake
    gcc
    gdb
    git
    git-crypt
    git-lfs
    gnumake
    gnupg
    inetutils
    openfortivpn
    wl-clipboard
  ];
}
