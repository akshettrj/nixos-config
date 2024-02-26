{ config, pkgs, lib, ... }:

{
  programs.lf = {
    enable = true;
    settings = {
      shell = ''${pkgs.zsh}/bin/zsh'';
      shellopts = "-euy";
      hidden = true;
      ifs = "\\n";
      number = true;
      relativenumber = true;
      icons = true;
      preview = true;
      drawbox = true;
    };
    keybindings = {
      "<enter>" = "shell";
      x = ''''$"$f"'';
      X = ''!"$f"'';
    };
  };
}
