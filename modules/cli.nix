{ pkgs, ... }:
let
  myaspell = pkgs.aspellWithDicts (
    d: with d; [
      en
      fr
    ]
  );
in
{
  environment.systemPackages = with pkgs; [
    appimage-run
    cmake
    gcc
    gdb
    git
    git-cliff
    git-crypt
    git-lfs
    gnumake
    gnupg
    inetutils
    jq
    just
    myaspell
    openfortivpn
    redis
    wl-clipboard
  ];
}
