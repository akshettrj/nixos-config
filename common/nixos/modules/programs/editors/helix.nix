{
  config,
  lib,
  pkgs,
  ...
}: {
  config = let
    pro_editors = config.propheci.programs.editors;
  in
    lib.mkIf pro_editors.helix.enable {
      environment.systemPackages = [pkgs.helix];
    };
}
