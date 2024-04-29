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

        time.timeZone = pro_system.timeZone;

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

        services.xserver = {
            xkb = { layout = "us"; options = "caps:swapescape"; };
            libinput.enable = true;
        };

        nix = {
            settings = {
                experimental-features = "nix-command flakes";
                auto-optimise-store = true;
                substituters = [
                    "https://propheci.cachix.org"
                ] ++ lib.optionals pro_nix.nix_community_cache [
                    "https://nix-community.cachix.org"
                ];
                trusted-public-keys = [
                    "propheci.cachix.org-1:CwV87KMySX+rhW88NhTx2hRzdNltV497nhXvWswFGDc="
                ] ++ lib.optionals pro_nix.nix_community_cache [
                    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
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
