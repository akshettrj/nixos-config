{ config, lib, ... }:

{
  config =
    let

      pro_clips = config.propheci.programs.clipboard_managers;

    in
    lib.mkIf (pro_clips.enable && pro_clips.copyq.enable) {

      services.copyq = {
        enable = true;
      };

    };
}
