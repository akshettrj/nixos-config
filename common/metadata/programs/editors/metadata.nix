{ pkgs }:

{
  helix = rec {
    pkg = pkgs.helix;
    cmd = "${pkg}/bin/hx";
  };
  neovim = rec {
    pkg = pkgs.neovim;
    cmd = "${pkg}/bin/nvim";
  };
}
