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
                udp_ports = [6969];
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
                main = { name = "Iosevka NF"; size = 15; };
                backups = [
                    { name = "JetBrainsMono NF"; size = 15; }
                ];
            };
            gtk = true;
            qt = true;
            cursor_size = 16;
            minimum_brightness = 40;
            wallpaper = "~/media/wallpapers/panda-2-1920×1080.png";
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
            rust.enable = true;
        };

        programs = {
            media = {
                audio = {
                    mpd = {
                        enable = true;
                        ncmpcpp.enable = true;
                    };
                };
            };
            social_media = {
                telegram.enable = true;
                discord.enable = false;
                slack.enable = false;
                beeper.enable = false;
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
                    font_size = 17;
                };
            };
            browsers = {
                enable = true;
                main = "brave";
                brave = {
                    enable = true;
                    cmd_args = [ "--force-device-scale-factor=1.3" ];
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
                main = "bemenu";
                bemenu = {
                    enable = true;
                    font_size = 13;
                };
            };
            zoxide.enable = true;
        };

        shells = {
            main = "zsh";
            aliases = {
                cp = "cp -rvi";
                rm = "rm -vi";
                rsync = "rsync -urvP";
            };
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
                use_official_packages = true;
                scroll_factor = 0.2;
                screenlock = "swaylock";
            };
            screenlocks = {
                swaylock.enable = true;
            };
        };
    };

    home-manager = {
        extraSpecialArgs = { inherit inputs; inherit pkgs; propheci = config.propheci; };
        users = {
            "akshettrj" = { propheci, ... }: {
                imports = [
                    ../../common/home-manager/configuration.nix
                ];

                propheci = propheci;
            };
        };
    };
}
