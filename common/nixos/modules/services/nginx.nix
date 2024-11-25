{ config, lib, ... }:

{
  config =
    let

      pro_nginx = config.propheci.services.nginx;

    in
    lib.mkIf pro_nginx.enable {

      services.nginx = {
        enable = true;
      };

      users.users.nginx.extraGroups = [ "acme" ];

    };
}
