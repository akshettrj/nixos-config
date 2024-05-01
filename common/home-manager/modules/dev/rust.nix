{ config, lib, pkgs, ... }:

{

    config = let

        pro_dev = config.propheci.dev;

    in lib.mkIf pro_dev.rust.enable {

        home.packages = [ pkgs.rustup ];

    };

}
