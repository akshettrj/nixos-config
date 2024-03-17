{ pkgs, lib, config, ... }:

{
  options = let
    inherit (lib) mkOption types;
  in {
    unison.enable = mkOption { type = types.bool; };
  };

  config = lib.mkIf config.unison.enable {
    services.unison = {
      enable = true;
    };
  };
}
