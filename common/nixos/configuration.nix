{ config, lib, pkgs, ... }:

{
    imports = [
        ../../options.nix
        ./modules
    ];

    config = let

        pro_nix = config.propheci.nix;
        pro_sec = config.propheci.security;
        pro_shells = config.propheci.shells;
        pro_system = config.propheci.system;
        pro_user = config.propheci.user;

        shells_meta = import ../metadata/programs/shells/metadata.nix { inherit pkgs; };

    in {

        boot.loader.grub = {
            enable = true;
            device = "nodev";
            efiSupport = true;
            useOSProber = true;
        };

        boot.loader.efi.canTouchEfiVariables = true;

        boot.tmp = {
            useTmpfs = true;
            cleanOnBoot = true;
        };

        networking.hostName = pro_system.hostname;
        networking.networkmanager.enable = true;

        time.timeZone = pro_system.time_zone;

        swapDevices = pro_system.swap_devices;

        users.users."${pro_user.username}" = {
            isNormalUser = true;
            extraGroups = [ "networkmanager" "wheel" ];
            initialPassword = "12345";
            shell = shells_meta."${pro_shells.main}".pkg;
        };

        security.sudo.extraRules = lib.mkIf pro_sec.sudo_without_password [
            {
                users = [ "${pro_user.username}" ];
                commands = [
                    { command = "ALL"; options = [ "NOPASSWD" ]; }
                ];
            }
        ];

        security.polkit.enable = lib.mkIf pro_sec.polkit.enable true;

        i18n.defaultLocale = "en_US.UTF-8";
        console = {
            font = "Lat2-Terminus16";
            useXkbConfig = true;
        };

        services.libinput.enable = true;
        services.xserver.xkb = { layout = "us"; options = "caps:swapescape"; };

        nix = {
            settings = {
                experimental-features = "nix-command flakes";
                auto-optimise-store = true;
                substituters =
                    [
                        "https://cache.nixos.org"
                        "https://propheci.cachix.org"
                    ]
                    ++ lib.optionals pro_nix.nix_community_cache [ "https://nix-community.cachix.org" ]
                    ++ lib.optionals pro_nix.hyprland_cache [ "https://hyprland.cachix.org" ]
                    ++ lib.optionals pro_nix.helix_cache [ "https://helix.cachix.org" ];
                trusted-public-keys =
                    [
                        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
                        "propheci.cachix.org-1:CwV87KMySX+rhW88NhTx2hRzdNltV497nhXvWswFGDc="
                    ]
                    ++ lib.optionals pro_nix.nix_community_cache [
                        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
                    ]
                    ++ lib.optionals pro_nix.hyprland_cache [
                        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
                    ]
                    ++ lib.optionals pro_nix.helix_cache [
                        "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
                    ];
                trusted-users = [
                    "root"
                    "${pro_user.username}"
                ];
            };
            gc = lib.mkIf pro_nix.garbage_collection.enable {
                automatic = true;
                dates = "weekly";
                options = "--delete-older-than 7d";
            };
        };

        environment.systemPackages = with pkgs; [
            # BASE + BASE-DEVEL
            autoconf
            automake
            binutils
            bison
            bzip2
            coreutils
            debugedit
            fakeroot
            file
            findutils
            flex
            gawk
            gcc
            gettext
            gitFull
            glibc
            gnugrep
            gnumake
            gnused
            gnutar
            groff
            gzip
            iproute2
            iputils
            libgcc
            libtool
            m4
            patch
            pciutils
            pkgconf
            procps
            psmisc
            shadow
            texinfo
            util-linux
            which
            xz

            # Essentials for root
            acpi
            curl
            htop
            lf
            lshw
            vim
            wget
        ];

        # DO NOT DELETE
        system.stateVersion = "23.11";

    };
}
