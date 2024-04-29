{ config, inputs, lib, pkgs, ... }:

{
    config = let

        pro_editors = config.propheci.programs.editors;

    in lib.mkIf pro_editors.neovim.enable {

        pkgs.overlays = pkgs.overlays ++ lib.optionals pro_editors.neovim.nightly [ inputs.neovim-nightly.overlays.default ];

        home.packages = [ pkgs.neovim ];

    };
}
