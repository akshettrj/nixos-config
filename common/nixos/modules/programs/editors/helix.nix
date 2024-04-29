{ config, inputs, lib, pkgs, ... }:

{
    config = let

        pro_editors = config.propheci.programs.editors;

    in lib.mkIf pro_editors.helix.enable {

        pkgs.overlays = pkgs.overlays ++ lib.optionals pro_editors.helix.nightly [ inputs.helix-nightly.overlays.default ];

        environment.systemPackages = [ pkgs.helix ];

    };
}
