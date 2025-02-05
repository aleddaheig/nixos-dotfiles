{ config, unstable, ... }:
{
  services.ollama = {
    enable = false;
    package = unstable.ollama-rocm;
    acceleration = "rocm";
    rocmOverrideGfx = "11.0.2";
    environmentVariables = {
      HCC_AMDGPU_TARGET = "gfx1103";
    };
  };

  nixpkgs.config.packageOverrides = unstable: {
    llama-cpp =
      ((builtins.getFlake "github:ggerganov/llama.cpp").packages.${builtins.currentSystem}.default)
      .overrideAttrs
        (
          finalAttrs: previousAttrs: {
            cmakeFlags = (previousAttrs.cmakeFlags ++ [ "-DAMDGPU_TARGETS=gfx1102" ]);
          }
        );
  };
  environment.systemPackages = with unstable; [ llama-cpp ];
}
