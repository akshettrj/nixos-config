{ config, lib, ... }:

{
  config =
    let

      pro_programs = config.propheci.programs;

    in
    lib.mkIf pro_programs.extra_utilities.drivedlgo.enable {

      environment.systemPackages = [ config.nur.repos.propheci.drivedlgo ];

    };
}
