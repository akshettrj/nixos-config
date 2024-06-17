{ config, inputs, lib, pkgs, ... }:

{
    config = let

        pro_editors = config.propheci.programs.editors;

    in lib.mkIf pro_editors.neovim.enable {

        home.packages = [ (
            if pro_editors.neovim.nightly then
                inputs.neovim.packages."${pkgs.system}".neovim
            else
                pkgs.neovim
        ) ];

    };
}
