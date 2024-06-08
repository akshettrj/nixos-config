{ config, lib, pkgs, ... }:

{
    config = let

        pro_video = config.propheci.programs.media.video;

    in lib.mkIf pro_video.vlc.enable {

        home.packages = [ pkgs.vlc ];

    };
}
