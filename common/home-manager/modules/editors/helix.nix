{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  config = let
    pro_editors = config.propheci.programs.editors;

    editors_meta = import ../../../metadata/programs/editors/metadata.nix {
      inherit config inputs pkgs;
    };
  in
    lib.mkIf pro_editors.helix.enable {
      home.packages = [editors_meta.helix.pkg];
    };
}
