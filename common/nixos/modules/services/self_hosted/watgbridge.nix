{ config, lib, ... }:

{
    config = let

        pro_watgbridge = config.propheci.services.self_hosted.watgbridge;

    in lib.mkIf pro_watgbridge.enable {

        services.watgbridge = pro_watgbridge.settings;

    };
}

