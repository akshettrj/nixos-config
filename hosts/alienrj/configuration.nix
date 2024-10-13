{ inputs, ... }:

{
    imports = [
        ./options.nix
        ./hardware-configuration.nix
        ../../common/nixos/configuration.nix

        "${inputs.propheci_secrets}/hosts/alienrj"
    ];

    # DO NOT DELETE
    system.stateVersion = "23.11";
}
