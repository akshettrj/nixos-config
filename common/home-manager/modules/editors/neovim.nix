{ config, lib, pkgs, ... }:

{
    config = let

        pro_editors = config.propheci.programs.editors;

    in lib.mkIf pro_editors.neovim.enable {

        home.packages = [ pkgs.neovim ];

    };
}
