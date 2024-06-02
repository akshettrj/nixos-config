{ pkgs }:

{
    flameshot = rec { pkg = pkgs.flameshot; bin = "${pkg}/bin/flameshot"; cmd = "${bin} gui"; };
}
