{ lib, ... }:

{
  options = let
    inherit (lib) mkOption types;
  in {
    nix-index.enable = mkOption { type = types.bool; };
  };

  config = {
    programs.nix-index = lib.mkIf config.nix-index.enable {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
    };
  };
}
