# system.nix
# Main system configuration
{ pkgs, unstable, ... }:
{
  imports = [ ./fprintd.nix ];

  # Enable the GNOME Desktop Environment with wayland.
  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    desktopManager.gnome = {
      enable = true;

      # Enable fractional scaling
      extraGSettingsOverrides = ''
        [org.gnome.mutter]
        experimental-features=['scale-monitor-framebuffer']
      '';
      extraGSettingsOverridePackages = [ pkgs.gnome.mutter ];

      # Workaround for Gnome-control-center missing schema
      sessionPath = [ pkgs.gnome.gpaste ];
    };
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages =
    (with pkgs; [
      drawing
      gnome.ghex
      gnome.gnome-tweaks
      gnome.gpaste
      gnome.networkmanager-openconnect
      gnome.gnome-sound-recorder
      gnomeExtensions.appindicator
      gnomeExtensions.blur-my-shell
      gnomeExtensions.dash-to-dock
      gnomeExtensions.night-theme-switcher
      pinentry-gnome3
    ])
    ++ (with unstable; [ sly ]);

  environment.gnome.excludePackages = with pkgs; [
    epiphany
    eog
  ];

  # Add env vars
  environment.sessionVariables = {
    QT_QPA_PLATFORM = "wayland;xcb";
    NIXOS_OZONE_WL = "1";
  };

}
