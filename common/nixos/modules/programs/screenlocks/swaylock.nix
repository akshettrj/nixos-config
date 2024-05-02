{ config, lib, ... }:

{
    config = let

        pro_deskenvs = config.propheci.desktop_environments;

    in lib.mkIf (pro_deskenvs.enable && pro_deskenvs.screenlocks.swaylock.enable) {

        security.pam.services.swaylock = {};

    };
}
