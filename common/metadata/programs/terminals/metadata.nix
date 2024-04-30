{ pkgs }:

{
  alacritty = rec {
    pkg = pkgs.alacritty;
    bin = "${pkg}/bin/alacritty";
    cmd = "${bin}";
    exec = "${cmd} -e";
  };
  wezterm = rec {
    pkg = pkgs.wezterm;
    bin = "${pkg}/bin/wezterm";
    cmd = "${bin} start --always-new-process";
    exec = "${cmd} -e";
  };
}
