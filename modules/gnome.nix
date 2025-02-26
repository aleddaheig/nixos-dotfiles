{
  pkgs,
  unstable,
  lib,
  ...
}:
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
      extraGSettingsOverridePackages = [ pkgs.mutter ];
      extraGSettingsOverrides = ''
        [org.gnome.mutter]
        experimental-features=['scale-monitor-framebuffer']
      '';

      # Workaround for Gnome-control-center missing schema
      sessionPath = [ pkgs.gpaste ];
    };
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # Enable sound with pipewire.
  # sound.enable = true;
  # hardware.pulseaudio.enable = false;
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
      pinentry-gnome3
      gpaste
      ghex
      gnome-tweaks
      networkmanager-openconnect
      gnome-sound-recorder
    ])
    ++ (with pkgs.gnomeExtensions; [
      appindicator
      blur-my-shell
      dash-to-dock
      night-theme-switcher
    ])
    ++ (with unstable; [
      sly
    ]);

  environment.gnome.excludePackages = with pkgs; [
    epiphany
    eog
    kgx
    evince
  ];

  programs.dconf.profiles.gdm.databases = [
    {
      settings."org/gnome/desktop/interface".scaling-factor = lib.gvariant.mkUint32 2;
    }
  ];

  # Add env vars
  environment.sessionVariables = lib.mkForce {
    #NAUTILUS_4_EXTENSION_DIR = "${pkgs.nautilus-python}/lib/nautilus/extensions-4";
    GSK_RENDERER = "ngl";
    NIXOS_OZONE_WL = "1";
  };

}
