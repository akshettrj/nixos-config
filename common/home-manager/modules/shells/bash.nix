{ config, lib, ... }:

{
    config = let

        pro_shells = config.propheci.shells;

    in lib.mkIf pro_shells.bash.enable {

        programs.bash.enable = true;

    };

}
