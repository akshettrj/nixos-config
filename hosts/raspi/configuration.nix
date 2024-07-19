{ config, inputs, lib, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
        ../../common/nixos/configuration.nix

        inputs.home-manager.nixosModules.home-manager
    ];

    boot.loader.grub.enable = lib.mkForce false;
    boot.loader.generic-extlinux-compatible.enable = true;

    boot.kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;

    hardware.enableRedistributableFirmware = true;

    propheci = {
        system = {
            hostname = "raspi";
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
                    root_login = "prohibit-password";
                    x11_forwarding = false;
                    public_keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC6S6G1MBgMoyiqroAz3gSKL548Xxr5XJ7CzRQECjc6ZotChGnRRENc3RjhAcHEi9dMKa3QOyfDSjw5/Cb59e7umpO6nhFtppIspzaR7MRD4WSveI3gOJ4faAfVYjeKLzITnvwHXYS6rJlVJjOKSFkq11cNhUhLi+T1U/wwNWVnCPBLid2APzE9bw2Mlz31QJrfS4d2sJr04rwEnmRkRCKqWvJazOMrINehZ1PEfYLDPk0ogJhWugG39unyYFgRuMRsXwicSeX/Y+aPJQ2t3sjcGm60w18r2JDyXr41wRvb+jTpPDdl4hNEebe28XrODfYfFsOHhTHgbZalYF9sqwUWly2KLvW/4qtn4IM+HINdMdv/14NgSjqj/H2hAhhlHIqZIXoTsV4xw7Uo8oVKbmcAl4kR4baFbkriKFBeGFh5LMi6A8+NL/Uyb8mBwUmMujdasTqHBB3iB70G2G3qEp/hgS0JrGFkJWkOps12I6JiK4zXQWAgLQElWsvcahfci8E=" ];
                };
            };
            tailscale.enable = true;
            xdg_portal.enable = false;
            telegram_bot_api.enable = false;
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
            direnv.enable = true;
            cachix.enable = true;
        };

        programs = {
            media.enable = false;
            editors = {
                main = "neovim";
                backup = "helix";
                neovim = {
                    enable = true;
                    nightly = true;
                };
                helix = {
                    enable = true;
                    nightly = false;
                };
            };
            terminals.enable = false;
            browsers.enable = false;
            file_explorers = {
                main = "lf";
                backup = "yazi";
                lf.enable = true;
                yazi = {
                    enable = true;
                    enableUeberzugpp = false;
                    enableFfmpeg = false;
                };
            };
            launchers.enable = false;
            screenshot_tools.enable = false;
            notification_daemons.enable = false;
            clipboard_managers.enable = false;
            bars.enable = false;
            screenlocks.enable = false;
            extra_utilities = {
                drivedlgo.enable = true;
                rclone.enable = true;
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

        desktop_environments.enable = false;
    };

    # DO NOT DELETE
    system.stateVersion = "24.05";

    home-manager = {
        extraSpecialArgs = {
            inherit inputs pkgs;
            propheci = config.propheci;
        };
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
