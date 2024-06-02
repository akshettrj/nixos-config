{ config, lib, ... }:

{
    config = let

        pro_deskenvs = config.propheci.desktop_environments;

    in lib.mkIf pro_deskenvs.screenlocks.hyprlock.enable {

        security.pam.services.hyprlock = {};

    };
}
