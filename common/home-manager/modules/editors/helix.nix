{
  config,
  inputs,
  lib,
  nixpkgs,
  pkgs,
  ...
}:

{
  config =
    let

      pro_editors = config.propheci.programs.editors;
    in
    lib.mkIf pro_editors.helix.enable {

      home.packages = [
        (
          if pro_editors.helix.nightly then
            inputs.helix-nightly.packages."${pkgs.system}".helix
          else
            pkgs.helix
        )
      ];
    };
}
