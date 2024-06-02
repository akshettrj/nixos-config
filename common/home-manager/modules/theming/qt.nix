{ config, lib, ... }:

{
    config = let

        pro_theming = config.propheci.theming;

    in lib.mkIf (pro_theming.enable && pro_theming.qt) {

        qt = {
            enable = true;
            platformTheme.name = "gtk3";
        };

    };
}
