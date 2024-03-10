{ config, pkgs, inputs, lib, ... }:

{
  options = let
    inherit (lib) mkOption types;
  in { };

  config = lib.mkIf config.theming.gtk {
    gtk = {
      enable = true;
      cursorTheme = {
        package = pkgs.whitesur-cursors;
        name = "WhiteSur Cursors";
        size = config.theming.cursorSize;
      };
      font = {
        name = config.theming.font;
        size = config.theming.fontSize;
      };
      iconTheme = {
        package = pkgs.papirus-icon-theme;
        name = "Papirus-Dark";
      };
      theme = {
        package = pkgs.materia-theme;
        name = "Materia-dark-compact";
      };
      gtk3 = {
        bookmarks = [];
      };
    };
  };
}
