{ config, inputs, lib, pkgs, ... }:

{
    imports = [ ./wayland.nix ];

    config = let

        pro_browsers = config.propheci.programs.browsers;
        pro_clips = config.propheci.programs.clipboard_managers;
        pro_deskenvs = config.propheci.desktop_environments;
        pro_file_explorers = config.propheci.programs.file_explorers;
        pro_launchers = config.propheci.programs.launchers;
        pro_mpd = config.propheci.programs.media.audio.mpd;
        pro_mpris = config.propheci.programs.media.services.mpris;
        pro_services = config.propheci.services;
        pro_hw = config.propheci.hardware;
        pro_ss_tools = config.propheci.programs.screenshot_tools;
        pro_terminals = config.propheci.programs.terminals;
        pro_theming = config.propheci.theming;

        browsers_meta = import ../../../../metadata/programs/browsers/metadata.nix { inherit pkgs; };
        clips_meta = import ../../../../metadata/programs/clipboard_managers/metadata.nix { inherit pkgs; };
        file_explorers_meta = import ../../../../metadata/programs/file_explorers/metadata.nix { inherit pkgs; };
        launchers_meta = import ../../../../metadata/programs/launchers/metadata.nix { inherit pkgs; };
        screenlocks_meta = import ../../../../metadata/programs/screenlocks/metadata.nix { inherit config inputs pkgs; };
        ss_tools_meta = import ../../../../metadata/programs/screenshot_tools/metadata.nix { inherit pkgs; };
        terminals_meta = import ../../../../metadata/programs/terminals/metadata.nix { inherit config inputs pkgs; };

        normal_desktops = lib.listToAttrs(builtins.map (ws: { name = toString(ws); value = toString(ws); }) (lib.range 1 9)) // { "0" = "10"; };
        alt_desktops = lib.listToAttrs(builtins.map (ws: { name = toString(ws - 10); value = toString(ws); }) (lib.range 11 19)) // { "0" = "20"; };

        launcher = pro_deskenvs.hyprland.launcher;
        ss_tool = pro_deskenvs.hyprland.screenshot_tool;
        screenlock = pro_deskenvs.hyprland.screenlock;
        clipboard_manager = pro_deskenvs.hyprland.clipboard_manager;

        hyprpaper_pkg = (
            if pro_deskenvs.hyprland.use_official_packages then
                inputs.hyprpaper.packages."${pkgs.system}".hyprpaper
            else
                pkgs.hyprpaper
        );
        hyprland_pkg = (
            if pro_deskenvs.hyprland.use_official_packages then
                inputs.hyprland.packages."${pkgs.system}".hyprland
            else
                pkgs.hyprland
        );

        startup_script = let
            clipboard_manager_meta = clips_meta."${clipboard_manager}";
            hyprpaper = "${hyprpaper_pkg}/bin/hyprpaper";
            hyprctl = "${hyprland_pkg}/bin/hyprctl";
            nm-applet = "${pkgs.networkmanagerapplet}/bin/nm-applet";
        in pkgs.writeShellScriptBin "start" ''

            # Setting up monitors
            ${
                lib.strings.concatStringsSep
                "\n"
                (
                    map
                    (mon: let
                        resolution = "${toString mon.width}x${toString mon.height}@${toString mon.refresh_rate}";
                        position = "${toString mon.x}x${toString mon.y}";
                        mon_config = if mon.enabled then "${resolution},${position},${mon.additional_settings}" else "disable";
                    in
                        /* sh */ ''
                            ${hyprctl} keyword monitor "${mon.name},${mon_config}"

                        '' + lib.optionalString mon.enabled /* sh */ ''

                            for wk in ${toString mon.workspaces}; do
                                ${hyprctl} keyword workspace "$wk,monitor:${mon.name}" &
                            done
                        ''
                    )
                    (pro_deskenvs.hyprland.monitors)
                )
            }

            pidof ${hyprpaper} && killall -9 ${hyprpaper}
            pidof ${clipboard_manager_meta.bin} && killall -9 ${clipboard_manager_meta.bin}
            pidof ${nm-applet} && killall -9 ${nm-applet}

            ${hyprpaper} &
            ${clipboard_manager_meta.cmd} &
            ${nm-applet} &

        '';

        kill_window_script = let

            jq = "${pkgs.jq}/bin/jq";
            xdotool = "${pkgs.xdotool}/bin/xdotool";

        in pkgs.writeShellScriptBin "kill_window" ''

            if [ "$1" = "-f" ]; then
                current_pid="$(hyprctl activewindow -j | ${jq} -r ".pid")"
                kill -9 $current_pid
            else
                if [ "$(hyprctl activewindow -j | ${jq} -r ".class")" = "Steam" ]; then
                    ${xdotool} getactivewindow windowunmap
                else
                    hyprctl dispatch killactive ""
                fi
            fi

        '';

    in lib.mkIf (pro_deskenvs.enable && pro_deskenvs.hyprland.enable) {

        assertions = [
            {
                assertion = screenlocks_meta."${screenlock}".wayland;
                message = "${screenlock} doesn't support Hyprland (Wayland)";
            }
            {
                assertion = pro_terminals.enable;
                message = "Hyprland is enabled but terminals are disabled";
            }
            {
                assertion = pro_launchers.enable;
                message = "Hyprland is enabled but app launchers are disabled";
            }
            {
                assertion =  pro_launchers."${launcher}".enable;
                message = "Hyprland's launcher is set to ${launcher} but its configuration is disabled";
            }
            {
                assertion = pro_browsers.enable;
                message = "Hyprland is enabled but browsers are disabled";
            }
            {
                assertion = pro_ss_tools.enable;
                message = "Hyprland is enabled but screenshot tools are disabled";
            }
            {
                assertion = pro_ss_tools."${ss_tool}".enable;
                message = "Hyprland's ss tool is set to ${ss_tool} but its configuration is disabled";
            }
            {
                assertion = pro_clips."${clipboard_manager}".enable;
                message = "Hyprland's clipboard manager is set to ${clipboard_manager} but its configuration is disabled";
            }
        ];

        propheci.desktop_environments.wayland.enable = lib.mkForce true;

        wayland.windowManager.hyprland = {
            enable = true;

            package = hyprland_pkg;

            systemd = {
                enable = true;
                variables = [ "--all" ];
            };
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
                    "SDL_VIDEODRIVER,wayland"
                    "LIBSEAT_BACKEND,logind"

                    "XCURSOR_THEME,${pro_theming.cursor.name}"
                    "XCURSOR_SIZE,${toString(pro_theming.cursor.size)}"

                ] ++ lib.optionals pro_hw.nvidia.enable [

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
                        xray = false;
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

                master.new_status = "master";

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
                "$resetSubmap" = "hyprctl dispatch submap reset";

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
                    builtins.attrValues (builtins.mapAttrs (key: desk: "$mainMod SHIFT, ${key}, movetoworkspacesilent, ${desk}") normal_desktops)
                ) ++ (
                    builtins.attrValues (builtins.mapAttrs (key: desk: "$mainMod ALT SHIFT, ${key}, movetoworkspacesilent, ${desk}") alt_desktops)
                ) ++ [
                    "$mainMod, BracketRight, workspace, m+1"
                    "$mainMod, BracketLeft, workspace, m-1"
                    "$mainMod SHIFT, BracketRight, workspace, r+1"
                    "$mainMod SHIFT, BracketLeft, workspace, r-1"

                    # SUPER
                    "$mainMod, C, exec, ${kill_window_script}/bin/kill_window"
                    "$mainMod, S, togglefloating"
                    "$mainMod, F, fullscreen, 0"
                    "$mainMod, MINUS, movetoworkspacesilent, special"
                    "$mainMod, M, fullscreen, 1"
                    "$mainMod, U, focusurgentorlast"
                    "$mainMod, N, cyclenext"
                    "$mainMod, P, cyclenext, prev"
                    "$mainMod, Tab, focusmonitor, +1"
                    "$mainMod, O, movewindow, mon:+1"
                    "$mainMod, R, togglesplit"
                    "$mainMod, Escape, exec, ${screenlocks_meta."${screenlock}".cmd}"

                    # SUPER + CTRL
                    "$mainMod CONTROL, Q, exit"
                    "$mainMod ALT, S, pin, active"

                    # SUPER + SHIFT
                    "$mainMod SHIFT, C, exec, ${kill_window_script}/bin/kill_window -f"
                    "$mainMod SHIFT, MINUS, togglespecialworkspace"

                    # TERMINALS AND FILE EXPLORERS
                    "$mainMod, Return, exec, ${terminals_meta."${pro_terminals.main}".cmd}"
                    "$mainMod SHIFT, Return, exec, ${terminals_meta."${pro_terminals.backup}".cmd}"
                    "$mainMod, E, exec, ${terminals_meta."${pro_terminals.main}".exec} ${file_explorers_meta."${pro_file_explorers.main}".bin}"
                    "$mainMod SHIFT, E, exec, ${terminals_meta."${pro_terminals.main}".exec} ${file_explorers_meta."${pro_file_explorers.backup}".bin}"

                    # LAUNCHER
                    "$mainMod, Space, exec, ${launchers_meta."${launcher}".bin}"

                    # BROWSER
                    "$mainMod, F1, exec, ${browsers_meta."${pro_browsers.main}".cmd}"

                    # # SCREENSHOTS
                    # "$mainMod SHIFT, S, exec, ${ss_tools_meta."${ss_tool}".cmd.region}"
                    # "$mainMod CONTROL, S, exec, ${ss_tools_meta."${ss_tool}".cmd.fullscreen}"

                ] ++ lib.optionals pro_services.pipewire.enable [

                    "$mainMod, F6, exec, wpctl set-mute '@DEFAULT_AUDIO_SINK@' toggle"
                    ",XF86AudioMute, exec, wpctl set-mute '@DEFAULT_AUDIO_SINK@' toggle"

                ] ++ lib.optionals pro_hw.pulseaudio.enable [

                    "$mainMod, F6, exec, pactl set-sink-mute '@DEFAULT_SINK@' toggle"
                    ",XF86AudioMute, exec, wpctl set-sink-mute '@DEFAULT_SINK@' toggle"

                ] ++ lib.optionals pro_mpd.enable [

                    "$mainMod, F9, exec, ${pkgs.mpc-cli}/bin/mpc -q prev"
                    "$mainMod, F10, exec, ${pkgs.mpc-cli}/bin/mpc -q toggle"
                    "$mainMod, F11, exec, ${pkgs.mpc-cli}/bin/mpc -q next"

                ] ++ lib.optionals pro_mpris.enable [

                    ",XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
                    ",XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
                    ",XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
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

                ] ++ lib.optionals pro_hw.pulseaudio.enable [

                    "$mainMod, F7, exec, pactl set-sink-volume '@DEFAULT_SINK@' '-1%'"
                    ",XF86AudioLowerVolume, exec, pactl set-sink-volume '@DEFAULT_SINK@' '-1%'"
                    "$mainMod, F8, exec, pactl set-sink-volume '@DEFAULT_SINK@' '+1%'"
                    ",XF86AudioRaiseVolume, exec, pactl set-sink-volume '@DEFAULT_SINK@' '+1%'"
                ];

                bindm = [
                    "$mainMod, mouse:272, movewindow"
                    "$mainMod, mouse:273, resizewindow"
                ];

                bindl = [
                    ",switch:on:Lid Switch, exec, ${screenlocks_meta."${screenlock}".cmd}"
                ];

                windowrulev2 = [
                    "workspace 9,class:org.telegram.desktop"
                    "workspace 10,class:teams-for-linux"
                    "workspace unset,class:org.telegram.desktop,title:^(Media viewer)$"
                    "float,title:Bitwarden"
                    "workspace 10,class:Beeper"
                    "pin,class:dragon-drop"
                ];
            };

            extraConfig = /* hyprlang */ ''

                # SCREENSHOTS BINDINGS
                bind = $mainMod SHIFT, S, submap, screenshot

                submap = screenshot

                bind = , Escape, submap, reset

                bind = , R, exec, $resetSubmap & ${ss_tools_meta."${ss_tool}".cmd.region}
                bind = , F, exec, $resetSubmap & ${ss_tools_meta."${ss_tool}".cmd.fullscreen}


                submap = reset
            '';
        };

        xdg.configFile."hypr/hyprpaper.conf".text = ''

            preload = ${pro_theming.wallpaper}
            ipc = off
            splash = false
            wallpaper = ,${pro_theming.wallpaper}

        '';

        home.packages = [
            hyprpaper_pkg
            pkgs.networkmanagerapplet
        ];


    };
}
