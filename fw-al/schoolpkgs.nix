{
  pkgs,
  unstable,
  customPkgs,
  ...
}:
let
  logisim-evolution-t = pkgs.logisim-evolution.overrideAttrs (old: {
    src = builtins.fetchurl {
      url = "https://reds-data.heig-vd.ch/logisim-evolution/logisim-evolution.t.jar";
      sha256 = "1sfilrl69lb71ar6sq9xfgwjhb17g6pz3pjd5f51jf9n0hpibj9n";
    };
  });
in
{
  programs.nix-ld.enable = true;
  environment.systemPackages =
    (with pkgs; [
      teams-for-linux
      xournalpp
      zeal
      onlyoffice-bin
    ])
    ++ (with customPkgs; [ windsurf ])
    ++ (with unstable; [ jetbrains.datagrip ])
    ++ [ logisim-evolution-t ];
}
