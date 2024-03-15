{ config, pkgs, lib, inputs, ... }:

{
  options = let
    inherit (lib) mkOption mkEnableOption types;
  in {
    wezterm = {
      enable = mkOption { type = types.bool; example = true; };
      fontSize = mkOption { type = types.number; example = 15; };
    };
  };

  config = lib.mkIf config.wezterm.enable {
    programs.wezterm = {
      enable = true;

      enableBashIntegration = true;
      enableZshIntegration = true;

      extraConfig = ''

        local wezterm = require("wezterm");
        local HOSTNAME = wezterm.hostname()

        local config = {};

        if wezterm.config_builder then
          config = wezterm.config_builder()
        end

        -- Appearance
        config.font = wezterm.font_with_fallback({
          "${config.theming.font}",
          "JetBrainsMono NF",
          "Lohit Devanagari",
        })
        config.font_size = ${toString(config.wezterm.fontSize)}

        config.window_frame = {
          font = wezterm.font_with_fallback({
            { family = "${config.theming.font}", weight = "ExtraBold" },
            { family = "JetBrainsMono NF", weight = "ExtraBold" },
            "Lohit Devanagari",
          }),
          font_size = ${toString(config.wezterm.fontSize - 1)},
        }

        config.color_scheme = 'Gruvbox Dark (Gogh)'
        config.hide_tab_bar_if_only_one_tab = true
        config.window_background_opacity = 0.95
        config.audible_bell = "Disabled"

        config.check_for_updates = false

        return config

      '';
    };
  };
}
