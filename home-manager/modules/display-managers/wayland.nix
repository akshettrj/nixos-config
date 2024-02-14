{ config, lib, pkgs, ... }:

{
  options = {
    wayland_packages.enable = lib.mkEnableOption("Enable Wayland");
  };

  config = lib.mkIf config.wayland_packages.enable {
    home.packages = [
      pkgs.wl-clipboard
    ];
  };
}
