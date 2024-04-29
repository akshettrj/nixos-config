{ lib, pkgs, ... }:

{
    options = let

        inherit (lib) mkOption types;

        known_browsers = lib.attrNames (import ./common/metadata/programs/browsers/metadata.nix { inherit pkgs; });
        known_desktop_environments = ["hyprland" "cosmic" "gnome"];
        known_editors = lib.attrNames (import ./common/metadata/programs/editors/metadata.nix { inherit pkgs; });
        known_file_explorers = lib.attrNames (import ./common/metadata/programs/file_explorers/metadata.nix { inherit pkgs; });
        known_launchers = lib.attrNames (import ./common/metadata/programs/launchers/metadata.nix { inherit pkgs; });
        known_shells = lib.attrNames (import ./common/metadata/programs/shells/metadata.nix { inherit pkgs; });
        known_terminals = lib.attrNames (import ./common/metadata/programs/terminals/metadata.nix { inherit pkgs; });
        known_screenlocks = lib.attrNames (import ./common/metadata/programs/screenlocks/metadata.nix { inherit pkgs; });

        font_type = lib.types.submodule {
            options = {
                name = mkOption { type = types.str; };
                size = mkOption { type = types.unsigned; };
            };
        };

    in {
        propheci = {
            # System Meta
            system = {
                hostname = mkOption { type = types.str; example = "alienrj"; };
                time_zone = mkOption { type = types.str; example = "Asia/Kolkata"; };
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
                    };
                };
                tailscale.enable = mkOption { type = types.bool; };
                xdg_portal.enable = mkOption { type = types.bool; };
            };

            # Nix/NixOS specific
            nix = {
                garbage_collection.enable = mkOption { type = types.bool; };
                nix_community_cache = mkOption { type = types.bool; };
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
                cursor_size = mkOption { type = types.unsigned; };
                minimum_brightness = mkOption { type = types.unsigned; };
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
            };

            programs = {
                media = {
                    audio = {
                        mpd = {
                            enable = mkOption { type = types.bool; };
                            ncmpcpp.enable = mkOption { type = types.bool; };
                        };
                    };
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
                        extensions = mkOption { type = types.any; };
                    };
                    chrome = {
                        enable = mkOption { type = types.bool; };
                        cmd_args = mkOption { type = types.listOf(types.str); };
                        extensions = mkOption { type = types.any; };
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
                    main = mkOption { type = types.enum(known_launchers); };
                    bemenu = {
                        enable = mkOption { type = types.bool; };
                        font_size = mkOption { type = types.unsigned; };
                    };
                };
                zoxide.enable = mkOption { type = types.bool; };
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
                    use_oficial_flake = mkOption { type = types.bool; };
                    scroll_factor = mkOption { type = types.number; };
                    screenlock = mkOption { type = types.enum(known_screenlocks); };
                };
                screenlocks = {
                    swaylock.enable = mkOption { type = types.bool; };
                };
            };
        };
    };
}
