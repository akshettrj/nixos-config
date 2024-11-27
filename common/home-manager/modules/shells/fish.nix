{
  config,
  lib,
  ...
}: {
  config = let
    pro_shells = config.propheci.shells;
  in
    lib.mkIf pro_shells.fish.enable {
      programs.fish = {
        enable = true;
      };
    };
}
