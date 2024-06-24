{ config, lib, pkgs, ... }:

{
    config = let

        pro_media = config.propheci.programs.media;

    in lib.mkIf (pro_media.enable && pro_media.services.mpris.enable) {

        home.packages = [ pkgs.playerctl ];

    };
}
