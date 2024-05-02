{ config, lib, ... }:

{
    config = let

        pro_browsers = config.propheci.programs.browsers;

    in lib.mkIf (pro_browsers.enable && pro_browsers.brave.enable) {

        programs.brave = {
            enable = true;
            commandLineArgs = pro_browsers.brave.cmd_args;
        };

    };
}
