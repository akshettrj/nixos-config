{ lib, pkgs, config, ... }:

{
  options = let
  inherit (lib) types mkOption;
  in {
    eza.enable = mkOption { type = types.bool; example = true; };
  };

  config = lib.mkIf config.eza.enable {
    programs.eza = {
      enable = true;
      enableAliases = true;
      git = true;
      icons = true;
    };
  };
}
