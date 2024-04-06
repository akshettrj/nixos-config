{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ../wayland.nix
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

  config = let
    kill_window = import ../../scripts/hyprland/kill_window.nix {inherit pkgs; hyprland-package = pkgs.hyprland;};
    brightnessScripts = import ../../scripts/brightness.nix { inherit pkgs; minBrightness = config.minBrightness; };
    launch_brave = import ../../scripts/launchers/brave.nix { inherit pkgs; scaleFactor = config.brave.scaleFactor; };
  in lib.mkIf config.hyprland.enable {
    wayland_packages.enable = lib.mkForce(true);

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
        "$mainMod, C, exec, ${kill_window}/bin/kill_window"
        "$mainMod CONTROL, Q, exit"
        "$mainMod, E, exec, ${config.hyprland.terminalCommandExecutor} ${pkgs.lf}/bin/lf"
        "$mainMod SHIFT, E, exec, ${config.hyprland.terminalCommandExecutor} ${pkgs.yazi}/bin/yazi"
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
        ''$mainMod, Escape, exec, ${pkgs.swaylock}/bin/swaylock -F --font="${config.theming.font}"''
        "$mainMod, Tab, focusmonitor, +1"
        "$mainMod, O, movewindow, mon:+1"
        "$mainMod, R, togglesplit"

        "$mainMod, H, movefocus, l"
        "$mainMod, L, movefocus, r"
        "$mainMod, K, movefocus, u"
        "$mainMod, J, movefocus, d"
        "$mainMod SHIFT, H, swapwindow, l"
        "$mainMod SHIFT, L, swapwindow, r"
        "$mainMod SHIFT, K, swapwindow, u"
        "$mainMod SHIFT, J, swapwindow, d"
      ] ++ (
        builtins.map (ws: "$mainMod, ${toString(ws)}, workspace, ${toString(ws)}") (lib.range 1 9)
      ) ++ (
        builtins.map (ws: "$mainMod ALT, ${toString(ws)}, workspace, 1${toString(ws)}") (lib.range 1 9)
      ) ++ (
        builtins.map (ws: "$mainMod SHIFT, ${toString(ws)}, movetoworkspace, ${toString(ws)}") (lib.range 1 9)
      ) ++ (
        builtins.map (ws: "$mainMod ALT SHIFT, ${toString(ws)}, movetoworkspace, 1${toString(ws)}") (lib.range 1 9)
      ) ++ [
        "$mainMod, 0, workspace, 10"
        "$mainMod ALT, 0, workspace, 20"

        "$mainMod SHIFT, 0, movetoworkspace, 10"
        "$mainMod ALT SHIFT, 0, movetoworkspace, 20"

        "$mainMod, BracketRight, workspace, m+1"
        "$mainMod, BracketLeft, workspace, m-1"
        "$mainMod SHIFT, BracketRight, workspace, r+1"
        "$mainMod SHIFT, BracketLeft, workspace, r-1"

        ", XF86AudioMute, exec, wpctl set-mute '@DEFAULT_AUDIO_SINK@' toggle"

        "$mainMod, F1, exec, ${launch_brave}/bin/launch_brave"
      ] ++ lib.optionals config.mpd.enable [
        "$mainMod, F9, exec, ${pkgs.mpc-cli}/bin/mpc -q prev"
        "$mainMod, F10, exec, ${pkgs.mpc-cli}/bin/mpc -q toggle"
        "$mainMod, F11, exec, ${pkgs.mpc-cli}/bin/mpc -q next"
      ];

      binde = [
        "$mainMod, Left, moveactive, -10 0"
        "$mainMod, Right, moveactive, 10 0"
        "$mainMod, Up, moveactive, 0 -10"
        "$mainMod, Down, moveactive, 0 10"

        '', XF86MonBrightnessDown, exec, ${brightnessScripts.down}/bin/brightnessdown''
        '', XF86MonBrightnessUp, exec, ${brightnessScripts.up}/bin/brightnessup''
        ''$mainMod, F2, exec, ${brightnessScripts.down}/bin/brightnessdown''
        ''$mainMod, F3, exec, ${brightnessScripts.up}/bin/brightnessup''

        "$mainMod, F7, exec, wpctl set-volume '@DEFAULT_AUDIO_SINK@' '1%-'"
        ", XF86AudioLowerVolume, exec, wpctl set-volume '@DEFAULT_AUDIO_SINK@' '1%-'"

        "$mainMod, F8, exec, wpctl set-volume '@DEFAULT_AUDIO_SINK@' '1%+'"
        ", XF86AudioRaiseVolume, exec, wpctl set-volume '@DEFAULT_AUDIO_SINK@' '1%+'"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
    };

    programs.swaylock = {
      enable = true;
      settings = {
        color = "000000";
        inside-color = "1F202A";
        line-color = "1F202A";
        ring-color = "bd93f9";
        text-color = "f8f8f2";
        layout-bg-color = "000000";
        layout-text-color = "f8f8f2";
        inside-clear-color = "6272a4";
        line-clear-color = "1F202A";
        ring-clear-color = "6272a4";
        text-clear-color = "1F202A";
        inside-ver-color = "bd93f9";
        line-ver-color = "1F202A";
        ring-ver-color = "bd93f9";
        text-ver-color = "1F202A";
        inside-wrong-color = "ff5555";
        line-wrong-color = "1F202A";
        ring-wrong-color = "ff5555";
        text-wrong-color = "1F202A";
        bs-hl-color = "ff5555";
        key-hl-color = "50fa7b";
        text-caps-lock-color = "f8f8f2";
      };
    };
  };
}
