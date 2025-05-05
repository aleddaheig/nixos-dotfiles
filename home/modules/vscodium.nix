{ config, pkgs, ... }:
let
  vscodium-marketplace = pkgs.vscodium.fhs.overrideAttrs (oldAttrs: {
    nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [ pkgs.jq ];
    postInstall = (oldAttrs.postInstall or "") + ''
      PRODUCT_JSON_LOCATION=$out/lib/vscode/resources/app/product.json
      jq '.extensionsGallery = {
        "serviceUrl": "https://marketplace.visualstudio.com/_apis/public/gallery",
        "cacheUrl": "https://vscode.blob.core.windows.net/gallery/index",
        "itemUrl": "https://marketplace.visualstudio.com/items"
      } | del(.linkProtectionTrustedDomains)' $PRODUCT_JSON_LOCATION > temp.json
      mv temp.json $PRODUCT_JSON_LOCATION
    '';
  });
in
{
  home.packages = [
    vscodium-marketplace
  ];
}
