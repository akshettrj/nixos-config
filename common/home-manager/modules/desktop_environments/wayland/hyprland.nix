{ config, inputs, lib, pkgs, ... }:

{
    imports = [ ./wayland.nix ];

    config = let

        pro_browsers = config.propheci.programs.browsers;
        pro_deskenvs = config.propheci.desktop_environments;
        pro_file_explorers = config.propheci.programs.file_explorers;
        pro_launchers = config.propheci.programs.launchers;
        pro_mpd = config.propheci.programs.media.audio.mpd;
        pro_services = config.propheci.services;
        pro_terminals = config.propheci.programs.terminals;
        pro_theming = config.propheci.theming;

        browsers_meta = import ../../../../metadata/programs/browsers/metadata.nix { inherit pkgs; };
        file_explorers_meta = import ../../../../metadata/programs/file_explorers/metadata.nix { inherit pkgs; };
        launchers_meta = import ../../../../metadata/programs/launchers/metadata.nix { inherit pkgs; };
        screenlocks_meta = import ../../../../metadata/programs/screenlocks/metadata.nix { inherit pkgs; };
        terminals_meta = import ../../../../metadata/programs/terminals/metadata.nix { inherit pkgs; };

        normal_desktops = lib.listToAttrs(builtins.map (ws: { name = toString(ws); value = toString(ws); }) (lib.range 1 9)) // { "0" = "10"; };
        alt_desktops = lib.listToAttrs(builtins.map (ws: { name = toString(ws); value = toString(ws); }) (lib.range 11 19)) // { "0" = "20"; };

        startup_script = pkgs.writeShellScriptBin "start" ''

            pidof hyprpaper && killall -9 hyprpaper


            hyprpaper &

        '';

    in lib.mkIf (pro_deskenvs.enable && pro_deskenvs.hyprland.enable) {

        propheci.desktop_environments.wayland.enable = lib.mkForce true;

        wayland.windowManager.hyprland = {
            enable = true;

            package = (
                if pro_deskenvs.hyprland.use_official_packages then
                    inputs.hyprland.packages."${pkgs.system}".hyprland
                else
                    pkgs.hyprland
            );

            systemd.enable = true;
            xwayland.enable = true;

            settings = {
                exec = "${startup_script}/bin/start";

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

                xwayland.force_zero_scaling = true;

                input = {
                    kb_layout = "us";
                    kb_options = "caps:swapescape";

                    repeat_rate = 50;
                    repeat_delay = 220;

                    follow_mouse = 2;

                    touchpad = {
                        disable_while_typing = true;
                        natural_scroll = false;
                        scroll_factor = pro_deskenvs.hyprland.scroll_factor;
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
                        xray = true;
                    };
                    drop_shadow = true;
                    shadow_range = 4;
                    shadow_render_power = 3;
                    "col.shadow" = "rgba(1a1a1aee)";
                };

                animations.enabled = false;

                dwindle = {
                    pseudotile = true;
                    preserve_split = true;
                };

                master.new_is_master = false;

                gestures = {
                    workspace_swipe = true;
                    workspace_swipe_fingers = 3;
                    workspace_swipe_forever = true;
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
                    # BASIC
                    "$mainMod, H, movefocus, l"
                    "$mainMod, L, movefocus, r"
                    "$mainMod, K, movefocus, u"
                    "$mainMod, J, movefocus, d"
                    "$mainMod SHIFT, H, swapwindow, l"
                    "$mainMod SHIFT, L, swapwindow, r"
                    "$mainMod SHIFT, K, swapwindow, u"
                    "$mainMod SHIFT, J, swapwindow, d"
                ] ++ (
                    builtins.attrValues (builtins.mapAttrs (key: desk: "$mainMod, ${key}, workspace, ${desk}") normal_desktops)
                ) ++ (
                    builtins.attrValues (builtins.mapAttrs (key: desk: "$mainMod ALT, ${key}, workspace, ${desk}") alt_desktops)
                ) ++ (
                    builtins.attrValues (builtins.mapAttrs (key: desk: "$mainMod SHIFT, ${key}, movetoworkspace, ${desk}") normal_desktops)
                ) ++ (
                    builtins.attrValues (builtins.mapAttrs (key: desk: "$mainMod ALT SHIFT, ${key}, movetoworkspace, ${desk}") alt_desktops)
                ) ++ [
                    "$mainMod, BracketRight, workspace, m+1"
                    "$mainMod, BracketLeft, workspace, m-1"
                    "$mainMod SHIFT, BracketRight, workspace, r+1"
                    "$mainMod SHIFT, BracketLeft, workspace, r-1"

                    # SUPER
                    "$mainMod, S, togglefloating"
                    "$mainMod, F, fullscreen, 0"
                    "$mainMod, MINUS, movetoworkspace, special"
                    "$mainMod, M, fullscreen, 1"
                    "$mainMod, U, focusurgentorlast"
                    "$mainMod, N, cyclenext"
                    "$mainMod, P, cyclenext, prev"
                    "$mainMod, Tab, focusmonitor, +1"
                    "$mainMod, O, movewindow, mon:+1"
                    "$mainMod, R, togglesplit"
                    "$mainMod, Escape, exec, ${screenlocks_meta."${pro_deskenvs.hyprland.screenlock}".cmd}"

                    # SUPER + CTRL
                    "$mainMod CONTROL, Q, exit"
                    "$mainMod CONTROL, S, pin, active"

                    # SUPER + SHIFT
                    "$mainMod SHIFT, MINUS, togglespecialworkspace"
                    "$mainMod SHIFT, F, fakefullscreen"

                ] ++ lib.optionals pro_terminals.enable [

                    "$mainMod, Return, exec, ${terminals_meta."${pro_terminals.main}".cmd}"
                    "$mainMod SHIFT, Return, exec, ${terminals_meta."${pro_terminals.backup}".cmd}"
                    "$mainMod, E, exec, ${terminals_meta."${pro_terminals.main}".exec} ${file_explorers_meta."${pro_file_explorers.main}".bin}"
                    "$mainMod SHIFT, E, exec, ${terminals_meta."${pro_terminals.main}".exec} ${file_explorers_meta."${pro_file_explorers.backup}".bin}"

                ] ++ lib.optionals pro_launchers.enable [

                    "$mainMod, Space, exec, ${launchers_meta."${pro_launchers.main}".bin}"

                ] ++ lib.optionals pro_browsers.enable [

                    "$mainMod, F1, exec, ${browsers_meta."${pro_browsers.main}".cmd}"

                ] ++ lib.optionals pro_services.pipewire.enable [

                    "$mainMod, F6, exec, wpctl set-mute '@DEFAULT_AUDIO_SINK@' toggle"
                    ",XF86AudioMute, exec, wpctl set-mute '@DEFAULT_AUDIO_SINK@' toggle"

                ] ++ lib.optionals pro_mpd.enable [

                    "$mainMod, F9, exec, ${pkgs.mpc-cli}/bin/mpc -q prev"
                    "$mainMod, F10, exec, ${pkgs.mpc-cli}/bin/mpc -q toggle"
                    "$mainMod, F11, exec, ${pkgs.mpc-cli}/bin/mpc -q next"
                ];

                binde = [
                    "$mainMod, Left, moveactive, -10 0"
                    "$mainMod, Right, moveactive, 10 0"
                    "$mainMod, Up, moveactive, 0 -10"
                    "$mainMod, Down, moveactive, 0 10"

                    ",XF86MonBrightnessDown, exec, brightnessdown"
                    ",XF86MonBrightnessUp, exec, brightnessup"
                    "$mainMod, F2, exec, brightnessdown"
                    "$mainMod, F3, exec, brightnessup"

                ] ++ lib.optionals pro_services.pipewire.enable [

                    "$mainMod, F7, exec, wpctl set-volume '@DEFAULT_AUDIO_SINK@' '1%-'"
                    ",XF86AudioLowerVolume, exec, wpctl set-volume '@DEFAULT_AUDIO_SINK@' '1%-'"
                    "$mainMod, F8, exec, wpctl set-volume '@DEFAULT_AUDIO_SINK@' '1%+'"
                    ",XF86AudioRaiseVolume, exec, wpctl set-volume '@DEFAULT_AUDIO_SINK@' '1%+'"
                ];

                bindm = [
                    "$mainMod, mouse:272, movewindow"
                    "$mainMod, mouse:273, resizewindow"
                ];

                windowrulev2 = [
                    "workspace 9,class:org.telegram.desktop"
                    "workspace unset,class:org.telegram.desktop,title:^(Media viewer)$"
                    "float,title:Bitwarden"
                    "workspace 10,class:Beeper"
                    "pin,class:dragon-drop"
                ];
            };
        };

        xdg.configFile."hypr/hyprpaper.conf".text = ''

            preload = ${pro_theming.wallpaper}
            ipc = off
            splash = false
            wallpaper = ,${pro_theming.wallpaper}

        '';

        home.packages = [(
            if pro_deskenvs.hyprland.use_official_packages then
                inputs.hyprpaper.packages."${pkgs.system}".hyprpaper
            else
                pkgs.hyprpaper
        )];


    };
}
