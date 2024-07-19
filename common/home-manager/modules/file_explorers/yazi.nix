{ config, lib, pkgs, ... }:

{
    config = let

        pro_explorers = config.propheci.programs.file_explorers;
        pro_shells = config.propheci.shells;

    in lib.mkIf pro_explorers.yazi.enable {

        programs.yazi = {
            enable = true;

            enableBashIntegration = lib.mkIf pro_shells.bash.enable true;
            enableFishIntegration = lib.mkIf pro_shells.fish.enable true;
            enableNushellIntegration = lib.mkIf pro_shells.nushell.enable true;
            enableZshIntegration = lib.mkIf pro_shells.zsh.enable true;
        };

        home.packages = lib.optionals pro_explorers.yazi.enableUeberzugpp [ pkgs.ueberzugpp ];

        propheci.programs.extra_utilities.ffmpeg.enable = lib.mkIf pro_explorers.yazi.enableFfmpeg (lib.mkForce true);

    };
}
