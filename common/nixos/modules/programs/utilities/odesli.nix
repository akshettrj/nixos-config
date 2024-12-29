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
    lib.mkIf pro_programs.extra_utilities.odesli.enable {
      environment.systemPackages = [
        inputs.odesli.packages."${pkgs.system}".default
      ];
    };
}
