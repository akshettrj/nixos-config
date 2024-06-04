{ pkgs }:

{
    flameshot = rec {
        pkg = pkgs.flameshot;
        bin = "${pkg}/bin/flameshot";
        cmd = {
            fullscreen = "${bin} full";
            region = "${bin} gui";
        };
        deps = {};
    };
    wayshot = rec {
        pkg = pkgs.wayshot;
        bin = "${pkg}/bin/wayshot";
        cmd = {
            fullscreen = "${bin} --cursor";
            region = ''${bin} --cursor --slurp "''$(${deps.slurp}/bin/slurp)"'';
        };
        deps = { slurp = pkgs.slurp; };
    };
    shotman = rec {
        pkg = pkgs.shotman;
        bin = "${pkg}/bin/shotman";
        cmd = {
            fullscreen = "shotman --capture output";
            region = "shotman --capture region";
        };
        deps = { slurp = pkgs.slurp; };
    };
}
