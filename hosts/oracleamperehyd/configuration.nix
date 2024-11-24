{ config, inputs, ... }:

{
    imports = [
        ./options.nix
        ./disk-config.nix
        ./hardware-configuration.nix
        ../../common/nixos/configuration.nix

        "${inputs.propheci_secrets}/hosts/oracleamperehyd"
    ];

    services.watgbridge = {
        enable = true;
        commonSettings = {
            requires = [ "tgbotapi.service" ];
            maxRuntime = null;
        };
        instances = {
            vi.workingDirectory = "${config.propheci.user.homedir}/work/watgbridge/vi";
            jio.workingDirectory = "${config.propheci.user.homedir}/work/watgbridge/jio";
        };
    };

    # DO NOT DELETE
    system.stateVersion = "24.11";
}
