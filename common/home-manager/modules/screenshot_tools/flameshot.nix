{
  config,
  lib,
  pkgs,
  ...
}:
{
  config =
    let
      pro_ss_tools = config.propheci.programs.screenshot_tools;

      ss_tools_meta = import ../../../../common/metadata/programs/screenshot_tools/metadata.nix {
        inherit pkgs;
      };
    in
    lib.mkIf (pro_ss_tools.enable && pro_ss_tools.flameshot.enable) {
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

      home.packages = lib.attrValues (ss_tools_meta.flameshot.deps);
    };
}
