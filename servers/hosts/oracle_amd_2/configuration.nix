{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../../common/nixos/oracle_amd/configuration.nix
  ];

  hostname = "oracle_amd_2";
}
