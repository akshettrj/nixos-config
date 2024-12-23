{
  pkgs,
  lib,
  config,
  ...
}:
{
  config =
    let
      pro_services = config.propheci.services;
    in
    lib.mkIf pro_services.printing.enable {
      # More at https://nixos.wiki/wiki/Printing

      services.printing.enable = true;

      environment.systemPackages = [
        pkgs.gutenprint
        pkgs.gutenprintBin
        pkgs.hplip
        pkgs.hplipWithPlugin
      ];
    };
}
