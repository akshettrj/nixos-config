{ config, lib, ... }:

{
  config =
    let

      pro_services = config.propheci.services;
      pro_user = config.propheci.user;

    in
    lib.mkIf pro_services.openssh.server.enable {

      services.openssh = {
        enable = true;
        ports = pro_services.openssh.server.ports;
        settings = {
          PasswordAuthentication = pro_services.openssh.server.password_authentication;
          PermitRootLogin = pro_services.openssh.server.root_login;
          X11Forwarding = pro_services.openssh.server.x11_forwarding;
        };
      };

      users.users.root.openssh.authorizedKeys.keys = pro_services.openssh.server.public_keys;
      users.users."${pro_user.username}".openssh.authorizedKeys.keys =
        pro_services.openssh.server.public_keys;

    };
}
