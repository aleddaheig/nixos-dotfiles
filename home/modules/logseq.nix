{
  config,
  lib,
  pkgs,
  ...
}:

let
  logseq = pkgs.logseq.overrideAttrs (oldAttrs: {
    postFixup = ''
              makeWrapper ${pkgs.electron_27}/bin/electron $out/bin/${oldAttrs.pname} \
      	  --set "LOCAL_GIT_DIRECTORY" ${pkgs.git} \
      	  --add-flags $out/share/${oldAttrs.pname}/resources/app \
      	  --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      	  --prefix LD_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath [ pkgs.stdenv.cc.cc.lib ]}"
    '';
  });
in
{
  home.packages = [ logseq ];
}
