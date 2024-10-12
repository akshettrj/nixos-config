{ config, inputs, lib, pkgs, ... }:

{
    imports = [
        ./options.nix
        ./hardware-configuration.nix
        ../../common/nixos/configuration.nix

        inputs.home-manager.nixosModules.home-manager
    ];

    boot.loader.grub.enable = lib.mkForce false;
    boot.loader.generic-extlinux-compatible.enable = true;

    boot.kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;

    hardware.enableRedistributableFirmware = true;

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
