# system.nix
# Main system configuration
{
  config,
  lib,
  pkgs,
  ...
}:
{

  # Enable networking
  networking.networkmanager.enable = true;

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
  environment.systemPackages = with pkgs; [
    appimage-run
    cmake
    corefonts
    gcc
    gdb
    git
    gnome.gnome-tweaks
    gnome.gpaste
    gnome.networkmanager-openconnect
    gnome.gnome-sound-recorder
    gnomeExtensions.appindicator
    gnomeExtensions.blur-my-shell
    gnomeExtensions.dash-to-dock
    gnomeExtensions.night-theme-switcher
    gnumake
    gnupg
    inetutils
    neovim
    openfortivpn
    pinentry-gnome3
    wireshark-qt
  ];

  environment.gnome.excludePackages = [ pkgs.epiphany ];

  fonts.packages = with pkgs; [
    ibm-plex
    merriweather
    noto-fonts
    noto-fonts-emoji
  ];

  # Add env vars
  environment.sessionVariables = {
    QT_QPA_PLATFORM = "wayland;xcb";
    NIXOS_OZONE_WL = "1";
  };

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark-qt;
  };

  services.fprintd.enable = true;

  security.pam.services.login.fprintAuth = false;
  # similarly to how other distributions handle the fingerprinting login
  security.pam.services.gdm-fingerprint = lib.mkIf (config.services.fprintd.enable) {
    text = ''
      auth       required                    pam_shells.so
      auth       requisite                   pam_nologin.so
      auth       requisite                   pam_faillock.so      preauth
      auth       required                    ${pkgs.fprintd}/lib/security/pam_fprintd.so
      auth       optional                    pam_permit.so
      auth       required                    pam_env.so
      auth       [success=ok default=1]      ${pkgs.gnome.gdm}/lib/security/pam_gdm.so
      auth       optional                    ${pkgs.gnome.gnome-keyring}/lib/security/pam_gnome_keyring.so

      account    include                     login

      password   required                    pam_deny.so

      session    include                     login
      session    optional                    ${pkgs.gnome.gnome-keyring}/lib/security/pam_gnome_keyring.so auto_start
    '';
  };

}
