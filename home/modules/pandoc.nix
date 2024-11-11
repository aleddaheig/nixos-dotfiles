{ pkgs, ... }:
{
  home.packages = with pkgs; [
    librsvg
    texlive.combined.scheme-small
  ];
  programs.pandoc = {
    package = pkgs.pandoc;
    enable = true;
    defaults = {
      filters = [ "${pkgs.mermaid-filter}/bin/mermaid-filter" ];
      metadata = {
        mainfont = "Times New Roman";
        sansfont = "Arial";
        monofont = "Courier New";
        fontsize = "12pt";
        geometry = "a4paper,margin=2cm";
      };
    };
  };
}
