{ pkgs, minBrightness }:

{
  up = pkgs.writeShellScriptBin "brightnessup" ''
    ${pkgs.brightnessctl}/bin/brightnessctl -q set -- '+'"''${1:-10}%"
  '';
  down = pkgs.writeShellScriptBin "brightnessdown" ''
    ${pkgs.brightnessctl}/bin/brightnessctl -q --min-value=${toString(minBrightness)} set -- '-'"''${1:-10}%"
  '';
}
