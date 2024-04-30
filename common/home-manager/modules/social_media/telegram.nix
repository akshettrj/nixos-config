{ config, inputs, lib, pkgs, ... }:

{
    config = let

        pro_social_media = config.propheci.programs.social_media;

    in lib.mkIf pro_social_media.telegram.enable {

        home.packages = [ inputs.telegram-desktop-userfonts.packages."${pkgs.system}".default ];

    };
}
