{ config, pkgs, lib, inputs, ... }:

{
    config = lib.mkIf config.propheci.desktop_environments.wayland.enable {
        home.packages = with pkgs; [
            wl-clipboard
            wev
        ];
    };
}
