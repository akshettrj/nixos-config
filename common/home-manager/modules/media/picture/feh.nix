{ config, lib, ... }:

{
    config = let

        pro_media = config.propheci.programs.media;
        pro_pics = config.propheci.programs.media.picture;

    in lib.mkIf (pro_media.enable && pro_pics.feh.enable) {

        programs.feh = {
            enable = true;
        };

    };
}
