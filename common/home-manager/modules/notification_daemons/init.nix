{
  config,
  lib,
  pkgs,
  ...
}:

{
  config =
    let

      pro_notifiers = config.propheci.programs.notification_daemons;

    in
    lib.mkIf pro_notifiers.enable {

      home.packages = [ pkgs.libnotify ];

    };
}
