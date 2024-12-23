{
  config,
  lib,
  pkgs,
  ...
}:
{
  config =
    let
      pro_social_media = config.propheci.programs.social_media;
    in
    lib.mkIf pro_social_media.slack.enable {
      home.packages = [ pkgs.slack ];
    };
}
