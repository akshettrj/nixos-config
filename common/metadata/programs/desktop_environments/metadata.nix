{ pkgs }:

{
    hyprland = rec { pkg = pkgs.hyprland; cmd = "${pkg}/bin/Hyprland"; };
}
