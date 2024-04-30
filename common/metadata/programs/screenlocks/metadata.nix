{ pkgs }:

{
  swaylock = rec {
    pkg = pkgs.swaylock;
    cmd = "${pkg}/bin/swaylock";
    wayland = true;
    x11 = true;
  };
}
