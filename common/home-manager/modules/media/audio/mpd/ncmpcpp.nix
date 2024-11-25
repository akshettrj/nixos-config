{ config, lib, ... }:

{
  config =
    let

      pro_media = config.propheci.programs.media;
      pro_mpd = config.propheci.programs.media.audio.mpd;

    in
    lib.mkIf (pro_media.enable && pro_mpd.enable && pro_mpd.ncmpcpp.enable) {

      programs.ncmpcpp = {
        enable = true;
        bindings = [
          {
            key = "k";
            command = "scroll_up";
          }
          {
            key = "j";
            command = "scroll_down";
          }
          {
            key = "shift-up";
            command = [
              "select_item"
              "scroll_up"
            ];
          }
          {
            key = "shift-down";
            command = [
              "select_item"
              "scroll_down"
            ];
          }
          {
            key = "l";
            command = "next_column";
          }
          {
            key = "h";
            command = "previous_column";
          }
        ];
        mpdMusicDir = config.xdg.userDirs.music;
        settings = {
          browser_display_mode = "columns";
          autocenter_mode = "yes";
          follow_now_playing_lyrics = "yes";
          ignore_leading_the = "yes";
          ignore_diacritics = "yes";
          default_place_to_search_in = "database";
          lyrics_directory = "~/.cache/lyrics";
          allow_for_physical_item_deletion = "yes";

          colors_enabled = "yes";
          main_window_color = "white";
          current_item_prefix = "$(blue)$r";
          current_item_suffix = "$/r$(end)";
          header_window_color = "cyan";
          volume_color = "red";
          progressbar_color = "cyan";
          progressbar_elapsed_color = "white";
          statusbar_color = "white";
          current_item_inactive_column_prefix = "$(cyan)$r";
          active_window_border = "blue";
          song_columns_list_format = "(10)[blue]{l} (30)[green]{t} (30)[red]{a} (30)[yellow]{b}";
          song_list_format = "{$3%n │ $9}{$7%a - $9}{$5%t$9}|{$8%f$9}$R{$6 │ %b$9}{$3 │ %l$9}";

          ## Alternative Interface ##;
          alternative_header_first_line_format = "$0$aqqu$/a {$6%a$9 - }{$3%t$9}|{$8%f$9} $0$atqq$/a$9";
          alternative_header_second_line_format = "{{$4%b$9}{ [$8%y$9]}}|{%D}";
          user_interface = "alternative";

          ## Classic Interface ##;
          song_status_format = " $6%a $7⟫⟫ $3%t $7⟫⟫ $4%b ";

          ## Visualizer ##;
          visualizer_data_source = "/tmp/mpd.fifo";
          visualizer_output_name = "my_fifo";
          # visualizer_sync_interval = "60";
          visualizer_type = "wave";
          visualizer_in_stereo = "yes";
          visualizer_look = "◆▋";

          ## Playlist Editor ##;
          playlist_editor_display_mode = "columns";

          ## Navigation ##;
          cyclic_scrolling = "yes";
          header_text_scrolling = "yes";
          jump_to_now_playing_song_at_start = "yes";
          lines_scrolled = "2";

          ## Other ##;
          system_encoding = "utf-8";
          regular_expressions = "extended";

          ## Selected tracks ##;
          selected_item_prefix = "* ";
          discard_colors_if_item_is_selected = "no";

          ## Seeking ##;
          incremental_seeking = "yes";
          seek_time = "1";

          ## Visibility ##;
          header_visibility = "yes";
          statusbar_visibility = "yes";
          titles_visibility = "yes";

          ## Progress Bar ##;
          progressbar_look = "=>-";

          ## Now Playing ##;
          now_playing_prefix = "> ";
          centered_cursor = "yes";

          # Misc;
          display_bitrate = "yes";
          enable_window_title = "yes";
          empty_tag_marker = "-";
          ncmpcpp_directory = "${config.xdg.cacheHome}/ncmpcpp";
          # execute_on_song_change = notify-send --icon ~/.config/dunst/music.png "Now Playing" "$(mpc --format '%title%\n%artist%' current)";
        };
      };

    };
}
