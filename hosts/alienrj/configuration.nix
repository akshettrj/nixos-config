{ config, inputs, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
        ../../common/nixos/configuration.nix

        inputs.home-manager.nixosModules.home-manager
    ];

    propheci = {
        system = {
            hostname = "alienrj";
            time_zone = "Asia/Kolkata";
            swap_devices = [];
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
            nvidia = {
                enable = true;
                package = config.boot.kernelPackages.nvidiaPackages.stable;
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
                    public_keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC6S6G1MBgMoyiqroAz3gSKL548Xxr5XJ7CzRQECjc6ZotChGnRRENc3RjhAcHEi9dMKa3QOyfDSjw5/Cb59e7umpO6nhFtppIspzaR7MRD4WSveI3gOJ4faAfVYjeKLzITnvwHXYS6rJlVJjOKSFkq11cNhUhLi+T1U/wwNWVnCPBLid2APzE9bw2Mlz31QJrfS4d2sJr04rwEnmRkRCKqWvJazOMrINehZ1PEfYLDPk0ogJhWugG39unyYFgRuMRsXwicSeX/Y+aPJQ2t3sjcGm60w18r2JDyXr41wRvb+jTpPDdl4hNEebe28XrODfYfFsOHhTHgbZalYF9sqwUWly2KLvW/4qtn4IM+HINdMdv/14NgSjqj/H2hAhhlHIqZIXoTsV4xw7Uo8oVKbmcAl4kR4baFbkriKFBeGFh5LMi6A8+NL/Uyb8mBwUmMujdasTqHBB3iB70G2G3qEp/hgS0JrGFkJWkOps12I6JiK4zXQWAgLQElWsvcahfci8E=" ];
                };
            };
            tailscale.enable = true;
            xdg_portal.enable = true;
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
                    email = "jindalakshett@gmail.com";
                };
                delta.enable = true;
                default_branch = "main";
            };
            direnv.enable = true;
        };

        programs = {
            media = {
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
                };
                picture = {
                    feh.enable = true;
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
                slack.enable = false;
                beeper.enable = true;
                teams.enable = true;
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
                yazi.enable = true;
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
                    use_official_package = true;
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
            defaults = { tty1 = "hyprland"; };
            wayland.enable = true;
            hyprland = {
                enable = true;
                use_official_packages = false;
                scroll_factor = 0.2;
                launcher = "bemenu";
                screenlock = "swaylock";
                screenshot_tool = "wayshot";
                clipboard_manager = "copyq";
            };
        };
    };

    # DO NOT DELETE
    system.stateVersion = "23.11";

    home-manager = {
        extraSpecialArgs = { inherit inputs; inherit pkgs; propheci = config.propheci; };
        users = {
            "${config.propheci.user.username}" = { propheci, ... }: {
                imports = [
                    ../../common/home-manager/configuration.nix
                ];

                propheci = propheci;
            };
        };
    };
}
