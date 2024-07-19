{ config, lib, pkgs, ... }:

{
    config = let

        pro_social_media = config.propheci.programs.social_media;

    in lib.mkIf pro_social_media.zulip.enable {

        home.packages = [ pkgs.zulip pkgs.zulip-term ];

    };
}
