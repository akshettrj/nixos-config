{
  config,
  lib,
  ...
}: {
  config = let
    pro_shells = config.propheci.shells;
  in
    lib.mkIf pro_shells.fish.enable {
      environment.pathsToLink = ["/share/fish"];

      programs.fish.enable = true;
    };
}
