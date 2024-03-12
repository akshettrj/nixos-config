{ config, pkgs, lib, ... }:

{
  options = let
  inherit (lib) mkOption mkEnableOption types;
  in {
    bemenu = {
      enable = mkOption { type = types.bool; description = "Whether to enable bemenu"; };

      fontSize = mkOption {
        type = types.int;
        example = 14;
        description = ''
          The font size used for bemenu
        '';
      };
    };
  };

  config = {
    programs.bemenu = lib.mkIf config.bemenu.enable {
      enable = true;
      settings = {
        prompt = "Run: ";
        ignorecase = true;
        hp = config.bemenu.fontSize - 4;
        line-height = config.bemenu.fontSize + 20;
        cw = 2;
        ch = config.bemenu.fontSize + 8;
        tf = "#268bd2";
        hf = "#268bd2";
        hb = "#444444";
        tb = "#444444";
        fn = "${config.theming.font} ${toString(config.bemenu.fontSize)}";
        no-cursor = true;
      };
    };
  };
}
