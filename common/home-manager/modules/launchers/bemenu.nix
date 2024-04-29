{ lib, config, pkgs, ... }:

{
    config = let

        pro_launchers = config.propheci.programs.launchers;
        pro_theming = config.propheci.theming;

    in lib.mkIf pro_launchers.bemenu.enable {

        programs.bemenu = {
            enable = true;

            settings = {
                prompt = "Run:";
                ignorecase = true;
                hp = pro_launchers.bemenu.font_size - 4;
                line-height = pro_launchers.bemenu.font_size + 20;
                cw = 2;
                ch = pro_launchers.bemenu.font_size + 8;
                tf = "#268bd2";
                hf = "#268bd2";
                hb = "#444444";
                tb = "#444444";
                fn = "${pro_theming.fonts.main.name} ${toString(pro_launchers.bemenu.font_size)}";
                no-cursor = true;
            };
        };

    };
}
