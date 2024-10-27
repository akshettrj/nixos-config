{ config, inputs, lib, pkgs, ... }:

{

    propheci = rec {
        system = {
            hostname = "alienrj";
            time_zone = "Asia/Kolkata";
            swap_devices = [
                {
                    device = "/var/lib/swapfile";
                    size = 6 * 1024;
                }
            ];
        };
        user = {
            username = "akshettrj";
            homedir = "/home/akshettrj";
        };
        security = {
            sudo_without_password = true;
            polkit.enable = true;
        };

        hardware = {
            bluetooth.enable = true;
            pulseaudio.enable = false;
            nvidia = {
                enable = true;
                package = config.boot.kernelPackages.nvidiaPackages.latest;
            };
        };

        # Various Services
        services = {
            printing.enable = false;
            firewall = {
                enable = true;
                tcp_ports = [22];
                udp_ports = [];
            };
            pipewire.enable = true;
            openssh = {
                server = {
                    enable = true;
                    ports = [22];
                    password_authentication = true;
                    root_login = "prohibit-password";
                    x11_forwarding = false;
                };
            };
            tailscale.enable = true;
            xdg_portal.enable = true;
            telegram_bot_api = {
                enable = true;
                port = 8082;
                data_dir = user.homedir + "/.local/share/telegram-bot-api";
            };
        };

        # Nix/NixOS specific
        nix = {
            garbage_collection.enable = true;
            nix_community_cache = true;
            hyprland_cache = true;
            helix_cache = true;
        };

        # Appearance
        theming = {
            enable = true;
            fonts = {
                nerdfonts = [ "JetBrainsMono" "Iosevka" ];
                main = { name = "Iosevka NF"; size = 13; };
                backups = [
                    { name = "JetBrainsMono NF"; size = 13; }
                ];
            };
            gtk = true;
            qt = true;
            cursor = {
                package = pkgs.whitesur-cursors;
                name = "WhiteSur-cursors";
                size = 26;
            };
            minimum_brightness = 40;
            wallpaper = "${inputs.wallpapers}/panda-2-1920×1080.png";
        };

        dev = {
            git = {
                enable = true;
                user = {
                    name = "Akshett Rai Jindal";
                };
                delta.enable = true;
                default_branch = "main";
            };
            direnv.enable = true;
            cachix.enable = true;
        };

        programs = {
            media = {
                enable = true;
                services.mpris.enable = true;
                audio = {
                    mpd = {
                        enable = true;
                        ncmpcpp.enable = true;
                    };
                };
                video = {
                    mpv.enable = true;
                    vlc.enable = false;
                    stremio.enable = true;
                };
                picture = {
                    feh.enable = true;
                    sxiv.enable = true;
                };
                documents = {
                    zathura = {
                        enable = true;
                        useMupdf = true;
                    };
                };
            };
            extra_utilities = {
                drivedlgo.enable = true;
                ffmpeg.enable = true;
                rclone.enable = true;
            };
            social_media = {
                telegram.enable = true;
                discord.enable = true;
                beeper.enable = true;
                teams.enable = true;
                zulip.enable = false;
            };
            editors = {
                main = "neovim";
                backup = "helix";
                neovim = {
                    enable = true;
                    nightly = true;
                };
                helix = {
                    enable = true;
                    nightly = true;
                };
            };
            terminals = {
                enable = true;
                main = "wezterm";
                backup = "alacritty";
                wezterm = {
                    enable = true;
                    font_size = 17;
                    enable_wayland = false;
                };
                alacritty = {
                    enable = true;
                    font_size = 11;
                };
            };
            browsers = {
                enable = true;
                main = "brave";
                brave = {
                    enable = true;
                    cmd_args = [ "--force-device-scale-factor=1.5" ];
                };
                firefox.enable = true;
                chromium.enable = false;
                chrome.enable = false;
            };
            file_explorers = {
                main = "lf";
                backup = "yazi";
                lf.enable = true;
                yazi = {
                    enable = true;
                    enableUeberzugpp = true;
                    enableFfmpeg = true;
                };
            };
            launchers = {
                enable = true;
                bemenu = {
                    enable = true;
                    font_size = 13;
                };
            };
            screenshot_tools = {
                enable = true;
                flameshot.enable = true;
                wayshot.enable = true;
                shotman.enable = true;
                hyprshot.enable = true;
            };
            screenlocks = {
                enable = true;
                swaylock.enable = true;
                hyprlock = {
                    enable = false;
                    background_image = "${inputs.wallpapers}/gta-5-wallpaper-1920×1080.jpg";
                };
            };
            clipboard_managers = {
                enable = true;
                copyq.enable = true;
            };
            notification_daemons = {
                enable = true;
                dunst = {
                    enable = true;
                    font_size = 10;
                };
            };
            bars = {
                enable = true;
                waybar = {
                    enable = true;
                    use_official_package = false;
                    heights = 28;
                    font_size = 12;
                    separator_size = 18;
                    icon_size = 15;
                    tray_spacing = 8;
                    is_laptop = true;
                    systemd_target = "hyprland-session.target";
                };
            };
        };

        shells = {
            main = "zsh";
            aliases = import (../../common/home-manager/modules/shells/aliases.nix);
            bash.enable = true;
            fish.enable = false;
            nushell.enable = false;
            zsh.enable = true;

            eza.enable = true;
            starship.enable = true;
            zoxide.enable = true;
        };

        desktop_environments = {
            enable = true;
            defaults = { "/dev/tty1" = "hyprland"; };
            wayland.enable = true;
            hyprland = {
                enable = true;
                use_official_packages = true;
                scroll_factor = 0.2;
                launcher = "bemenu";
                screenlock = "swaylock";
                screenshot_tool = "hyprshot";
                clipboard_manager = "copyq";
                monitors = [
                    {
                        enabled = true;
                        name = "eDP-1";
                        width = 2560; height = 1600; refresh_rate = 60;
                        x = 0; y = 0;
                        additional_settings = "1.6";
                        workspaces = (lib.range 1 10);
                    }
                    {
                        enabled = true;
                        name = "HDMI-A-1";
                        width = 1920; height = 1080; refresh_rate = 60;
                        x = 2560; y = 0;
                        additional_settings = "1";
                        workspaces = (lib.range 11 20);
                    }
                ];
            };
        };
    };

}
