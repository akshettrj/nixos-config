{ config, lib, ... }:

{
  config =
    let

      pro_navidrome = config.propheci.services.self_hosted.navidrome;
      pro_nginx = config.propheci.services.nginx;

    in
    lib.mkIf pro_navidrome.enable {

      assertions = [
        {
          assertion = (if pro_navidrome.nginx.enable then pro_nginx.enable else true);
          message = "Navidrome's nginx is enabled, but global nginx is not";
        }
      ];

      users.users.navidrome.extraGroups = [ "acme" ];

      services.navidrome = {
        enable = true;
        settings = pro_navidrome.settings;
      };

      services.nginx = lib.mkIf pro_navidrome.nginx.enable {
        virtualHosts."${pro_navidrome.nginx.hostname}" =
          let
            certDir = config.security.acme.certs."${pro_navidrome.nginx.hostname}".directory;
          in
          {
            forceSSL = pro_navidrome.nginx.enable_ssl;
            sslCertificate = "${certDir}/cert.pem";
            sslCertificateKey = "${certDir}/key.pem";
            locations."/" = {
              proxyPass = "http://localhost:${toString pro_navidrome.settings.Port}";
              extraConfig = ''
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection 'upgrade';
                proxy_set_header Host $host;
                proxy_cache_bypass $http_upgrade;
              '';
            };
          };
      };

      propheci.programs.extra_utilities.ffmpeg.enable = (lib.mkForce true);

    };
}
