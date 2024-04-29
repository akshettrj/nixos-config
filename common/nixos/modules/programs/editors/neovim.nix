{ config, inputs, lib, pkgs, ... }:

{
    config = let

        pro_editors = config.propheci.programs.editors;

    in lib.mkIf pro_editors.neovim.enable {

        programs.neovim = {
            enable = true;
            defaultEditor = if pro_editors.main == "neovim" then true else false;
        };

        pkgs.overlays = pkgs.overlays ++ lib.optionals pro_editors.neovim.nightly [ inputs.neovim-nightly.overlays.default ];

        environment.systemPackages = [ pkgs.neovim ];

    };
}
