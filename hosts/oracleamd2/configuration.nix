{ config, inputs, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
        ../../common/nixos/configuration.nix

        inputs.home-manager.nixosModules.home-manager
    ];

    propheci = {
        system = {
            hostname = "oracleamd2";
            time_zone = "EST";
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
            sudo_without_password = false;
            polkit.enable = true;
        };

        hardware = {
            bluetooth.enable = true;
            nvidia.enable = false;
        };

        # Various Services
        services = {
            printing.enable = false;
            firewall = {
                enable = true;
                tcp_ports = [22];
                udp_ports = [];
            };
            pipewire.enable = false;
            openssh = {
                server = {
                    enable = true;
                    ports = [22];
                    password_authentication = true;
                    root_login = "no";
                    x11_forwarding = false;
                };
            };
            tailscale.enable = true;
            xdg_portal.enable = false;
        };

        # Nix/NixOS specific
        nix = {
            garbage_collection.enable = true;
            nix_community_cache = true;
            hyprland_cache = true;
            helix_cache = true;
        };

        # Appearance
        theming.enable = false;

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
            rust.enable = false;
        };

        programs = {
            media = {
                audio = {
                    mpd = {
                        enable = false;
                        ncmpcpp.enable = false;
                    };
                };
            };
            social_media = {
                telegram.enable = false;
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
            terminals.enable = false;
            browsers.enable = false;
            file_explorers = {
                main = "lf";
                backup = "yazi";
                lf.enable = true;
                yazi.enable = true;
            };
            launchers.enable = false;
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

        desktop_environments.enable = false;
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
