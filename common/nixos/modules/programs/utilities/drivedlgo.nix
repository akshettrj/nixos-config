{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  config = let
    pro_programs = config.propheci.programs;
  in
    lib.mkIf pro_programs.extra_utilities.drivedlgo.enable {
      environment.systemPackages = [inputs.nixur.legacyPackages."${pkgs.system}".drivedlgo];
    };
}
