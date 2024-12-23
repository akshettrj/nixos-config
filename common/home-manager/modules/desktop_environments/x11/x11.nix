{
  config,
  pkgs,
  lib,
  ...
}:
{
  config =
    let
      pro_deskenvs = config.propheci.desktop_environments;
    in
    lib.mkIf pro_deskenvs.enable {
      home.packages = with pkgs; [
        xclip
        xdotool
      ];
    };
}
