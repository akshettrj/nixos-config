{
  config,
  lib,
  pkgs,
  ...
}:

{
  config =
    let

      pro_programs = config.propheci.programs;

    in
    lib.mkIf pro_programs.extra_utilities.obs.enable {

      environment.systemPackages = [
        pkgs.obs-studio
      ];

    };
}
