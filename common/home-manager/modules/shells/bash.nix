{ config, lib, pkgs, ... }:

{
    config = let

        pro_shells = config.propheci.shells;

    in lib.mkIf pro_shells.bash.enable {

        environment.pathsToLink = [ "/share/bash-completion" ];

        programs.bash.enable = true;
    };

}
