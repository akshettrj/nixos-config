{
  config,
  lib,
  pkgs,
  ...
}: {
  config = let
    pro_programs = config.propheci.programs;
  in
    lib.mkIf pro_programs.extra_utilities.ueberzugpp.enable {
      environment.systemPackages = [pkgs.ueberzugpp];
    };
}
