{ pkgs, private, ... }:
{
  services.printing = {
    enable = true;
    drivers = [ pkgs.cups-kyodialog ];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  hardware.printers = {
    ensurePrinters = [
      {
        name = "Kyocera_FS-C2626MFP";
        location = "Home";
        deviceUri = "socket://${private.ip.printer1}";
        model = "Kyocera/Kyocera_FS-C2626MFP.ppd";
        ppdOptions = {
          PageSize = "A4";
        };
      }
    ];
    ensureDefaultPrinter = "Kyocera_FS-C2626MFP";
  };
}
