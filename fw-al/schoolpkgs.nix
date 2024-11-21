{ pkgs, unstable, ... }:
{
  environment.systemPackages =
    with pkgs;
    [
      teams-for-linux
      xournalpp
      zeal
    ]
    ++ (with unstable; [ jetbrains.datagrip ]);
}
