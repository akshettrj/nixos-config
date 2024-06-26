{ config, inputs, lib, pkgs, ... }:

{
    options = let

        inherit (lib) mkOption types;

        known_browsers = lib.attrNames (import ./common/metadata/programs/browsers/metadata.nix { inherit pkgs; });
        known_clipboard_managers = lib.attrNames (import ./common/metadata/programs/clipboard_managers/metadata.nix { inherit pkgs; });
        known_desktop_environments = (import ./common/metadata/programs/desktop_environments/metadata.nix { inherit config; inherit inputs; inherit pkgs; });
        known_editors = lib.attrNames (import ./common/metadata/programs/editors/metadata.nix { inherit config; inherit inputs; inherit pkgs; });
        known_file_explorers = lib.attrNames (import ./common/metadata/programs/file_explorers/metadata.nix { inherit pkgs; });
        known_launchers = lib.attrNames (import ./common/metadata/programs/launchers/metadata.nix { inherit pkgs; });
        known_shells = lib.attrNames (import ./common/metadata/programs/shells/metadata.nix { inherit pkgs; });
        known_screenlocks = lib.attrNames (import ./common/metadata/programs/screenlocks/metadata.nix { inherit config; inherit inputs; inherit pkgs; });
        known_screenshot_tools = lib.attrNames (import ./common/metadata/programs/screenshot_tools/metadata.nix { inherit pkgs; });
        known_terminals = lib.attrNames (import ./common/metadata/programs/terminals/metadata.nix { inherit pkgs; });

        font_type = lib.types.submodule {
            options = {
                name = mkOption { type = types.str; };
                size = mkOption { type = types.ints.unsigned; };
            };
        };

    in {
        propheci = {
            # System Meta
            system = {
                hostname = mkOption { type = types.str; example = "alienrj"; };
                time_zone = mkOption { type = types.str; example = "Asia/Kolkata"; };
                swap_devices = mkOption { type = types.anything; };
            };

            # User Meta
            user = {
                username = mkOption { type = types.str; example = "akshettrj"; };
                homedir = mkOption { type = types.str; example = "/home/akshettrj"; };
            };

            security = {
                sudo_without_password = mkOption { type = types.bool; };
                polkit.enable = mkOption { type = types.bool; };
            };

            hardware = {
                bluetooth.enable = mkOption { type = types.bool; };
                nvidia = {
                    enable = mkOption { type = types.bool; };
                    package = mkOption {
                        type = types.anything;
                        example = config.boot.kernelPackages.nvidiaPackages.stable;
                    };
                };
            };

            # Various Services
            services = {
                printing.enable = mkOption { type = types.bool; };
                firewall = {
                    enable = mkOption { type = types.bool; };
                    tcp_ports = mkOption { type = types.listOf(types.port); example = [22]; };
                    udp_ports = mkOption { type = types.listOf(types.port); example = [6969]; };
                };
                pipewire.enable = mkOption { type = types.bool; };
                openssh = {
                    server = {
                        enable = mkOption { type = types.bool; };
                        ports = mkOption { type = types.listOf(types.port); example = [22 993]; };
                        password_authentication = mkOption { type = types.bool; };
                        root_login = mkOption { type = types.enum(["yes" "without-password" "prohibit-password" "forced-comands-only" "no"]); };
                        x11_forwarding = mkOption { type = types.bool; };
                        public_keys = mkOption { type = types.listOf(types.str); };
                    };
                };
                tailscale.enable = mkOption { type = types.bool; };
                xdg_portal.enable = mkOption { type = types.bool; };
                telegram_bot_api = {
                    enable = mkOption { type = types.bool; };
                    port = mkOption { type = types.port; };
                    data_dir = mkOption { type = types.oneOf [ types.str types.path ]; };
                };
            };

            # Nix/NixOS specific
            nix = {
                garbage_collection.enable = mkOption { type = types.bool; };
                nix_community_cache = mkOption { type = types.bool; };
                hyprland_cache = mkOption { type = types.bool; };
                helix_cache = mkOption { type = types.bool; };
            };

            # Appearance
            theming = {
                enable = mkOption { type = types.bool; };
                fonts = {
                    nerdfonts = mkOption { type = types.listOf(types.str); };
                    main = mkOption { type = font_type; };
                    backups = mkOption { type = types.listOf(font_type); };
                };
                gtk = mkOption { type = types.bool; };
                qt = mkOption { type = types.bool; };
                cursor = {
                    package = mkOption { type = types.package; };
                    name = mkOption { type = types.str; };
                    size = mkOption { type = types.ints.unsigned; };
                };
                minimum_brightness = mkOption { type = types.ints.unsigned; };
                wallpaper = mkOption { type = types.path; };
            };

            dev = {
                git = {
                    enable = mkOption { type = types.bool; };
                    user = {
                        name = mkOption { type = types.str; };
                        email = mkOption { type = types.str; };
                    };
                    delta.enable = mkOption { type = types.bool; };
                    default_branch = mkOption { type = types.str; };
                };
                direnv.enable = mkOption { type = types.bool; };
            };

            programs = {
                media = {
                    enable = mkOption { type = types.bool; };
                    services = {
                        mpris.enable = mkOption { type = types.bool; };
                    };
                    audio = {
                        mpd = {
                            enable = mkOption { type = types.bool; };
                            ncmpcpp.enable = mkOption { type = types.bool; };
                        };
                    };
                    video = {
                        mpv.enable = mkOption { type = types.bool; };
                        vlc.enable = mkOption { type = types.bool; };
                    };
                    picture = {
                        feh.enable = mkOption { type = types.bool; };
                    };
                };
                extra_utilities = {
                    enable = mkOption { type = types.bool; };
                    drivedlgo.enable = mkOption { type = types.bool; };
                    ffmpeg.enable = mkOption { type = types.bool; };
                    rclone.enable = mkOption { type = types.bool; };
                };
                social_media = {
                    enable = mkOption { type = types.bool; };
                    telegram.enable = mkOption { type = types.bool; };
                    discord.enable = mkOption { type = types.bool; };
                    beeper.enable = mkOption { type = types.bool; };
                    slack.enable = mkOption { type = types.bool; };
                    teams.enable = mkOption { type = types.bool; };
                };
                editors = {
                    main = mkOption { type = types.enum(known_editors); example = "neovim"; };
                    backup = mkOption { type = types.enum(known_editors); example = "helix"; };
                    neovim = {
                        enable = mkOption { type = types.bool; };
                        nightly = mkOption { type = types.bool; };
                    };
                    helix = {
                        enable = mkOption { type = types.bool; };
                        nightly = mkOption { type = types.bool; };
                    };
                };
                terminals = {
                    enable = mkOption { type = types.bool; };
                    main = mkOption { type = types.enum(known_terminals); };
                    backup = mkOption { type = types.enum(known_terminals); };
                    wezterm = {
                        enable = mkOption { type = types.bool; };
                        font_size = mkOption { type = types.number; };
                        enable_wayland = mkOption { type = types.bool; };
                    };
                    alacritty = {
                        enable = mkOption { type = types.bool; };
                        font_size = mkOption { type = types.number; };
                    };
                };
                browsers = {
                    enable = mkOption { type = types.bool; };
                    main = mkOption { type = types.enum(known_browsers); };
                    brave = {
                        enable = mkOption { type = types.bool; };
                        cmd_args = mkOption { type = types.listOf(types.str); };
                    };
                    firefox.enable = mkOption { type = types.bool; };
                    chromium = {
                        enable = mkOption { type = types.bool; };
                        cmd_args = mkOption { type = types.listOf(types.str); };
                        extensions = mkOption { type = types.anything; };
                    };
                    chrome = {
                        enable = mkOption { type = types.bool; };
                        cmd_args = mkOption { type = types.listOf(types.str); };
                        extensions = mkOption { type = types.anything; };
                    };
                };
                file_explorers = {
                    main = mkOption { type = types.enum(known_file_explorers); };
                    backup = mkOption { type = types.enum(known_file_explorers); };
                    lf.enable = mkOption { type = types.bool; };
                    yazi.enable = mkOption { type = types.bool; };
                };
                launchers = {
                    enable = mkOption { type = types.bool; };
                    bemenu = {
                        enable = mkOption { type = types.bool; };
                        font_size = mkOption { type = types.ints.unsigned; };
                    };
                };
                screenshot_tools = {
                    enable = mkOption { type = types.bool; };
                    flameshot.enable = mkOption { type = types.bool; };
                    wayshot.enable = mkOption { type = types.bool; };
                    shotman.enable = mkOption { type = types.bool; };
                };
                screenlocks = {
                    enable = mkOption { type = types.bool; };
                    swaylock.enable = mkOption { type = types.bool; };
                    hyprlock = {
                        enable = mkOption { type = types.bool; };
                        background_image = mkOption { type = types.path; };
                    };
                };
                clipboard_managers = {
                    enable = mkOption { type = types.bool; };
                    copyq.enable = mkOption { type = types.bool; };
                };
                notification_daemons = {
                    enable = mkOption { type = types.bool; };
                    dunst = {
                        enable = mkOption { type = types.bool; };
                        font_size = mkOption { type = types.ints.unsigned; };
                    };
                };
                bars = {
                    enable = mkOption { type = types.bool; };
                    waybar = {
                        enable = mkOption { type = types.bool; };
                        use_official_package = mkOption { type = types.bool; };
                        heights = mkOption { type = types.ints.unsigned; };
                        font_size = mkOption { type = types.ints.unsigned; };
                        separator_size = mkOption { type = types.ints.unsigned; };
                        icon_size = mkOption { type = types.ints.unsigned; };
                        tray_spacing = mkOption { type = types.ints.unsigned; };
                        is_laptop = mkOption { type = types.bool; };
                        systemd_target = mkOption { type = types.str; };
                    };
                };
            };

            shells = {
                main = mkOption { type = types.enum(known_shells); };
                aliases = mkOption { type = types.attrsOf(types.str); };
                bash.enable = mkOption { type = types.bool; };
                fish.enable = mkOption { type = types.bool; };
                nushell.enable = mkOption { type = types.bool; };
                zsh.enable = mkOption { type = types.bool; };

                eza.enable = mkOption { type = types.bool; };
                starship.enable = mkOption { type = types.bool; };
                zoxide.enable = mkOption { type = types.bool; };
            };

            desktop_environments = {
                enable = mkOption { type = types.bool; };
                defaults = mkOption { type = types.attrsOf(types.enum(known_desktop_environments)); };
                wayland.enable = mkOption { type = types.bool; };
                hyprland = {
                    enable = mkOption { type = types.bool; };
                    use_official_packages = mkOption { type = types.bool; };
                    scroll_factor = mkOption { type = types.number; };
                    screenlock = mkOption { type = types.enum(known_screenlocks); };
                    launcher = mkOption { type = types.enum(known_launchers); };
                    screenshot_tool = mkOption { type = types.enum(known_screenshot_tools); };
                    clipboard_manager = mkOption { type = types.enum(known_clipboard_managers); };
                };
            };
        };
    };
}
