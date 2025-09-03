{ unstable, ... }:
{
  services.usbmuxd.enable = true;

  environment.systemPackages = with unstable; [
    socat
    libusbmuxd
    usbfluxd
  ];
}
