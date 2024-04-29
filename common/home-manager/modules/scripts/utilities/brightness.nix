{ config, lib, pkgs, ... }:

{
    config = let

        pro_theming = config.prophec.theming;

    in lib.mkIf pro_theming.enable rec {

        brightnessdown = pkgs.writeShellScriptBin "brightnessdown" ''
            ${pkgs.brightnessctl}/bin/brightnessctl -q --min-value=${toString(pro_theming.minimum_brightness)} set -- '-'"''${1:-10}%"
        '';
        brightnessup = pkgs.writeShellScriptBin "brightnessup" ''
            ${pkgs.brightnessctl}/bin/brightnessctl -q set -- '+'"''${1:-10}%"
        '';

        home.packages = [ brightnessdown brightnessup ];

    };
}
