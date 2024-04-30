{
  config,
  lib,
  pkgs,
  ...
}:

{
  config =
    let

      pro_theming = config.propheci.theming;

      brightnessdown = pkgs.writeShellScriptBin "brightnessdown" ''
        ${pkgs.brightnessctl}/bin/brightnessctl -q --min-value=${toString (pro_theming.minimum_brightness)} set -- '-'"''${1:-10}%"
      '';
      brightnessup = pkgs.writeShellScriptBin "brightnessup" ''
        ${pkgs.brightnessctl}/bin/brightnessctl -q set -- '+'"''${1:-10}%"
      '';
    in
    lib.mkIf pro_theming.enable {

      home.packages = [
        brightnessdown
        brightnessup
      ];
    };
}
