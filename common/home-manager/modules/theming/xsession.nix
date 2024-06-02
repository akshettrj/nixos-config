{ config, lib, ... }:

{
    config = let

        pro_theming = config.propheci.theming;

    in lib.mkIf pro_theming.enable {

        xsession.enable = true;

        home.pointerCursor = {
            gtk.enable = true;
            x11.enable = true;
            package = pro_theming.cursor.package;
            name = pro_theming.cursor.name;
            size = pro_theming.cursor.size;
        };

    };
}
