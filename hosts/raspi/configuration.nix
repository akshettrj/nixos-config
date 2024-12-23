{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./options.nix
    ./hardware-configuration.nix
    ../../common/nixos/configuration.nix
  ];

  boot.loader.grub.enable = lib.mkForce false;
  boot.loader.generic-extlinux-compatible.enable = true;

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;

  hardware.enableRedistributableFirmware = true;

  # DO NOT DELETE
  system.stateVersion = "24.05";
}
