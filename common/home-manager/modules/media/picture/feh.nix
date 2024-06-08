{ config, lib, ... }:

{
    config = let

        pro_pics = config.propheci.programs.media.picture;

    in lib.mkIf pro_pics.feh.enable {

        programs.feh = {
            enable = true;
        };

    };
}
