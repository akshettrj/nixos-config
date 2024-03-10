{ config, pkgs, inputs, lib, ... }:

{
  options = let
    inherit (lib) mkOption types;
  in { };

  config = lib.mkIf config.theming.qt {
    qt = {
      enable = true;
      platformTheme = "gtk3";
    };
  };
}
