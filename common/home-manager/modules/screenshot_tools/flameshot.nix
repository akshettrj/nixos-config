{ config, lib, ... }:

{
    config = let

        pro_ss_tools = config.propheci.programs.screenshot_tools;

    in lib.mkIf pro_ss_tools.flameshot.enable {

        services.flameshot = {
            enable = true;
            settings = {
                General = {
                    savePath = "${config.xdg.userDirs.pictures}/screenshots";
                    showDesktopNotification = true;
                    copyPathAfterSave = true;
                    showStartupLaunchMessage = false;
                    disabledTrayIcon = false;
                };
            };
        };

    };
}
