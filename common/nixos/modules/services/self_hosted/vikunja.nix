{ config, lib, ... }:

{
    config = let

        pro_nginx = config.propheci.services.nginx;
        pro_vikunja = config.propheci.services.self_hosted.vikunja;

    in lib.mkIf pro_vikunja.enable {

        assertions = [{
            assertion = (if pro_vikunja.nginx.enable then pro_nginx.enable else true);
            message = "Vikunja's nginx is enabled, but global nginx is not";
        }];

        services.vikunja = {
            enable = true;
            frontendHostname = pro_vikunja.frontend_hostname;
            frontendScheme = pro_vikunja.frontend_scheme;
            port = pro_vikunja.port;
            settings = pro_vikunja.settings;
        };

        services.nginx = lib.mkIf pro_vikunja.nginx.enable {
            virtualHosts."${pro_vikunja.nginx.hostname}" = let
                certDir = config.security.acme.certs."${pro_vikunja.frontend_hostname}".directory;
            in {
                forceSSL = pro_vikunja.nginx.enable_ssl;
                sslCertificate = "${certDir}/cert.pem";
                sslCertificateKey = "${certDir}/key.pem";
                locations."/" = {
                    proxyPass = "http://localhost:${toString pro_vikunja.port}";
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

    };
}
