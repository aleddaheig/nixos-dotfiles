{ stdenv
, inputs
, callPackage
, fetchurl
, nixosTests
, commandLineArgs ? ""
, useVSCodeRipgrep ? stdenv.hostPlatform.isLinux
, ...
}:
let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  plat =
    {
      x86_64-linux = "linux-x64";
      # Pretty sure these below aren't currently supported.
      # x86_64-darwin = "macos-x64";
      # aarch64-linux = "linux-arm64";
      # aarch64-darwin = "macos-arm64";
      # armv7l-linux = "linux-armhf";
    }.${system} or throwSystem;

  archive_fmt = if stdenv.hostPlatform.isDarwin then "zip" else "tar.gz";

  sha256 = {
    x86_64-linux = "9a98223f0629b0e0219d82902b8c38d18dd08dd8b6700d2739419a385344d17f";
  }.${system} or throwSystem;

in
# https://windsurf-stable.codeium.com/api/update/linux-x64/stable/latest
callPackage "${inputs.nixpkgs}/pkgs/applications/editors/vscode/generic.nix" rec {
  inherit commandLineArgs useVSCodeRipgrep;

  version = "1.3.10";
  pname = "windsurf";

  executableName = "windsurf";
  longName = "Windsurf";
  shortName = "windsurf";

  src = fetchurl {
    url = "https://windsurf-stable.codeiumdata.com/${plat}/stable/61d65579650f356494469f86c21fb953834289a0/Windsurf-${plat}-${version}.${archive_fmt}";
    inherit sha256;
  };

  sourceRoot = "Windsurf";

  tests = nixosTests.vscodium;

  updateScript = "nil";

  meta = {
    description = "Windsurf - A vsCodium fork + AI features";
    platforms = [ "x86_64-linux" ];
  };
}
