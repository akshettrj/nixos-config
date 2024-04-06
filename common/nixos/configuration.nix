{ config, lib, pkgs, ... }:

{
    imports = [
        ../../options.nix
        ./modules
    ];

    config = let

        pro_nix = config.propheci.nix;

    in {

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

        # DO NOT DELETE
        system.stateVersion = "23.11";

    };
}
