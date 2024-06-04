{ config, pkgs, lib, ... }:

{
    config = let

        pro_deskenvs = config.propheci.desktop_environments;

    in lib.mkIf (pro_deskenvs.enable && pro_deskenvs.wayland.enable) {
        home.packages = with pkgs; [
            wl-clipboard
            wev
            xdotool
        ];
    };
}
