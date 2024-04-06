{ config, lib, ... }:

{
    config = let

        pro_browsers = config.propheci.softwares.browsers;

    in lib.mkIf pro_browsers.firefox.enable {

        programs.firefox.enable = true;

    };
}
