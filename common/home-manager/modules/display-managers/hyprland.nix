{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./wayland.nix
  ];

  options = let
  inherit (lib) mkOption mkEnableOption types;
  in {
    hyprland = {
      enable = mkOption { type = types.bool; description = "Whether to enable hyprland"; };

      terminalCommand = mkOption {
        type = types.str;
        example = "wezterm start --always-new-process";
        description = ''
          The terminal command to run
        '';
      };

      backupTerminalCommand = mkOption {
        type = types.str;
        example = "alacritty";
        description = ''
          The backup terminal command to run
        '';
      };

      terminalCommandExecutor = mkOption {
        type = types.str;
        example = "wezterm -e";
        description = ''
          The terminal command to run other commands
        '';
      };

      backupTerminalCommandExecutor = mkOption {
        type = types.str;
        example = "alacritty -e";
        description = ''
          The backup terminal command to run other commands
        '';
      };
    };
  };

  config = lib.mkIf config.hyprland.enable {
    wayland_packages.enable = true;

    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages."${pkgs.system}".hyprland;

      systemd.enable = true;
      xwayland.enable = true;
    };

    wayland.windowManager.hyprland.settings = {
      env = [
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "QT_QPA_PLATFORM,wayland;xcb"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "SDL_VIDEODRIVER,wayland"
        "LIBSEAT_BACKEND,logind"
        "LIBVA_DRIVER_NAME,nvidia"
        "WLR_NO_HARDWARE_CURSORS,1"
      ];

      xwayland = {
        force_zero_scaling = true;
      };

      input = {
        kb_layout = "us";
        kb_options = "caps:swapescape";

        repeat_rate = 50;
        repeat_delay = 220;

        follow_mouse = 2;

        touchpad = {
          disable_while_typing = true;
          natural_scroll = false;
          scroll_factor = 0.2;
          tap-and-drag = true;
          tap-to-click = false;
          drag_lock = true;
        };
      };

      general = {
        gaps_in = 2;
        gaps_out = 2;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";

        layout = "dwindle";

        no_focus_fallback = true;

        resize_on_border = true;
      };

      decoration = {
        rounding = 0;

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          xray = false;
        };

        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";
      };

      animations = {
        enabled = false;
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_is_master = false;
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
        workspace_swipe_forever = false;
        workspace_swipe_invert = false;
        workspace_swipe_cancel_ratio = 0.001;
      };

      device = {
        name = "epic-mouse-v1";
        sensitivity = -0.5;
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        animate_manual_resizes = true;
        animate_mouse_windowdragging = true;
        disable_autoreload = false;
        enable_swallow = true;
        focus_on_activate = false;
        vfr = false;
      };

      "$mainMod" = "SUPER";

      bind = [
        "$mainMod, Return, exec, ${config.hyprland.terminalCommand}"
        "$mainMod SHIFT, Return, exec, ${config.hyprland.backupTerminalCommand}"
        # TODO: Add command to kill windows :p
        "$mainMod CONTROL, Q, exit"
        "$mainMod, E, exec, ${config.hyprland.terminalCommandExecutor} lf"
        "$mainMod SHIFT, E, exec, ${config.hyprland.terminalCommandExecutor} yazi"
        "$mainMod, S, togglefloating"
        "$mainMod CONTROL, S, pin, active"
        "$mainMod, F, fullscreen, 0"
        "$mainMod, MINUS, movetoworkspace, special"
        "$mainMod SHIFT, MINUS, togglespecialworkspace"
        "$mainMod SHIFT, F, fakefullscreen"
        "$mainMod, M, fullscreen, 1"
        "$mainMod, U, focusurgentorlast"
        "$mainMod, N, cyclenext"
        "$mainMod, P, cyclenext, prev"
        "$mainMod, Space, exec, ${pkgs.bemenu}/bin/bemenu-run"
      ];
    };
  };
}
