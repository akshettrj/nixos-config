{ config, pkgs, lib, ... }:

{
  options = {
    zoxide.enable = lib.mkEnableOption("Enable zoxide for shells");
  };

  config = {
    programs.zoxide = lib.mkIf config.zoxide.enable {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
  };
}
