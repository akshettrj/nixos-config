{
  config,
  lib,
  ...
}: {
  config = let
    pro_shells = config.propheci.shells;
  in
    lib.mkIf pro_shells.nushell.enable {
      programs.nushell = {
        enable = true;
      };
    };
}
