{ config, inputs, pkgs, ... }:

{
    imports = [
        ./options.nix
        ./hardware-configuration.nix
        ../../common/nixos/configuration.nix

        "${inputs.propheci_secrets}/hosts/oracleamd1"

        inputs.home-manager.nixosModules.home-manager
    ];

    # DO NOT DELETE
    system.stateVersion = "23.11";

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
