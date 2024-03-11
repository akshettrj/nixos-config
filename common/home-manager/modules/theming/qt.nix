{ config, pkgs, inputs, lib, ... }:

{
  config = lib.mkIf config.theming.qt {
    qt = {
      enable = true;
      platformTheme = "gtk3";
    };
  };
}
