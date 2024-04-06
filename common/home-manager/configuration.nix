{ config, lib, pkgs, ... }:

{
    imports = [
        ../../options.nix
        ./modules/
    ];
}
