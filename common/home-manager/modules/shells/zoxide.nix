{ config, pkgs, lib, ... }:

{
  options = let
    inherit (lib) mkOption types;
  in {
    zoxide.enable = lib.mkOption { type = types.bool; description = "Enable zoxide for shells"; };
  };

  config = {
    programs.zoxide = lib.mkIf config.zoxide.enable {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
  };
}
