{ config, lib, ... }:

{
  config =
    let

      pro_shells = config.propheci.shells;
      pro_terminals = config.propheci.programs.terminals;
      pro_theming = config.propheci.theming;
    in
    lib.mkIf pro_terminals.wezterm.enable {

      programs.wezterm = {
        enable = true;

        enableBashIntegration = lib.mkIf pro_shells.bash.enable true;
        enableZshIntegration = lib.mkIf pro_shells.zsh.enable true;

        extraConfig = ''
          local wezterm = require("wezterm");

          local config = {};

          if wezterm.config_builder then
              config = wezterm.config_builder()
          end

          config.font = wezterm.font_with_fallback({
              "${pro_theming.fonts.main.name}",
              ${
                lib.strings.concatStringsSep ",\n" (map (font: ''"${font.name}"'') (pro_theming.fonts.backups))
              }
          })
          config.font_size = ${toString (pro_terminals.wezterm.font_size)}

          config.window_frame = {
              font = wezterm.font_with_fallback({

              }),
              font_size = ${toString (pro_terminals.wezterm.font_size - 1)},
          }

          config.color_scheme = "Gruvbox Dark (Gogh)"
          config.hide_tab_bar_if_only_one_tab = false
          config.window_background_opacity = 0.95
          config.audible_bell = "Disabled"
          config.check_for_updates = false
          config.hide_mouse_cursor_when_typing = false

          config.enable_wayland = ${if pro_terminals.wezterm.enable_wayland then "true" else "false"}

          return config
        '';
      };
    };
}
