{
  config,
  lib,
  ...
}:
{
  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita";
  };

  # Add env vars
  environment.sessionVariables = {
    QT_STYLE_OVERRIDE = lib.mkDefault "adwaita";
    QT_QPA_PLATFORM = lib.mkDefault "xcb;wayland";
    QT_SCREEN_SCALE_FACTORS = lib.mkDefault "1.5";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = lib.mkDefault "1";
  }
  // lib.optionalAttrs (config.services.xserver.enable) {
    GDK_SCALE = "1.5";
  };
}
