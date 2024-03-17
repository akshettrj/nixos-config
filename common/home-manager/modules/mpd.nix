{ lib, pkgs, config, ... }:

{
  options = let
    inherit (lib) mkOption types;
  in {
    mpd.enable = mkOption { type = types.bool; };
  };

  config = lib.mkIf config.mpd.enable {
    services.mpd = {
      enable = true;
      extraConfig = ''
        auto_update "yes"
        restore_paused "yes"

        audio_output {
          type "pulse"
          name "Music"
        }

        audio_output {
          type "fifo"
          name "ncmpcpp visualizer"
          path "/tmp/mpd.fifo"
          format "44100:16:2"
        }
      '';
    };

    home.packages = [ pkgs.ncmpcpp ];
  };
}
