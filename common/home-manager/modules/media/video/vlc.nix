{
  config,
  lib,
  pkgs,
  ...
}: {
  config = let
    pro_media = config.propheci.programs.media;
    pro_video = config.propheci.programs.media.video;
  in
    lib.mkIf (pro_media.enable && pro_video.vlc.enable) {
      home.packages = [pkgs.vlc];
    };
}
