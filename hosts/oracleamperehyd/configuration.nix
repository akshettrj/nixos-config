{ config, inputs, ... }:

{
    imports = [
        ./options.nix
        ./disk-config.nix
        ./hardware-configuration.nix
        ../../common/nixos/configuration.nix

        "${inputs.propheci_secrets}/hosts/oracleamperehyd"
    ];

    # DO NOT DELETE
    system.stateVersion = "24.11";
}
