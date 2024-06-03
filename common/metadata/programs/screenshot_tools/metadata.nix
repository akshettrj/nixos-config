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
            region = ''${bin} --cursor --slurp "''$(${deps.slurp})"'';
        };
        deps = { slurp = pkgs.slurp; };
    };
    shotman = rec {
        pkg = pkgs.shotman;
        bin = "${pkg}/bin/shotman";
        cmd = {
            fullscreen = "";
            region = "";
        };
        deps = { slurp = pkgs.slurp; };
    };
}
