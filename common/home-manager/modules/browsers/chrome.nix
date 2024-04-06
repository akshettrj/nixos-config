{ config, lib, pkgs, ... }:

{
    config = let

        pro_browsers = config.propheci.softwares.browsers;

    in lib.mkIf pro_browsers.chrome.enable {

        programs.chrome = {
            enable = true;
            commandLineArgs = pro_browsers.chrome.cmd_args;
        };

    };
}
