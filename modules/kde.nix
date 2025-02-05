{ pkgs, unstable, lib, ... }:
{
  environment.systemPackages =
    (with pkgs; [
      adwaita-qt
    ])
    ++ (with pkgs.kdePackages; [
      okular
      qtwayland
    ]);

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita";
  };

  # Add env vars
  environment.sessionVariables = lib.mkForce {
    QT_STYLE_OVERRIDE = "adwaita";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
  };
}
