{
  config,
  lib,
  pkgs,
  ...
}:

{
  config =
    let

      pro_browsers = config.propheci.programs.browsers;

    in
    lib.mkIf (pro_browsers.enable && pro_browsers.chromium.enable) {

      programs.chromium = {
        enable = true;
        commandLineArgs = pro_browsers.chromium.cmd_args;
      };

    };
}
