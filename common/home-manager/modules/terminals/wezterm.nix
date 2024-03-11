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
          "Iosevka NF",
          "JetBrainsMono NF",
          "Lohit Hindi",
        })
        config.font_size = ${toString(config.wezterm.fontSize)}

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
