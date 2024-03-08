{ config, lib, pkgs, ... }:

{
  options = let
    inherit (lib) mkOption types;
  in {
    wayland_packages.enable = lib.mkOption { type = types.bool; description = "Enable Wayland"; };
  };

  config = lib.mkIf config.wayland_packages.enable {
    home.packages = [
      pkgs.wl-clipboard
    ];
  };
}
