{ lib, pkgs, ... }:
let
  specialPkgs = import ../../.private/specialPkgs.nix { inherit pkgs; };
  logseq = pkgs.logseq.overrideAttrs (oldAttrs: {
    postFixup = ''
              makeWrapper ${specialPkgs.electronLogseq}/bin/electron $out/bin/${oldAttrs.pname} \
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
