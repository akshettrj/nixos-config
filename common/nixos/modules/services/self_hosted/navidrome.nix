{ config, lib, ... }:

{
    config = let

        pro_navidrome = config.propheci.services.self_hosted.navidrome;

    in lib.mkIf pro_navidrome.enable {

        services.navidrome = let
            certDir = config.security.acme.certs."${pro_navidrome.nginx.hostname}".directory;
        in {
            enable = true;
            settings = pro_navidrome.settings // {
                Port = pro_navidrome.port;
                BaseUrl = "${pro_navidrome.frontend_scheme}://${pro_navidrome.frontend_hostname}";
                TLSCert = "${certDir}/cert.pem";
                TLSKey = "${certDir}/key.pem";
            };
        };

        services.nginx = lib.mkIf pro_navidrome.nginx.enable {
            enable = true;
            virtualHosts."${pro_navidrome.nginx.hostname}" = let
                certDir = config.security.acme.certs."${pro_navidrome.nginx.hostname}".directory;
            in {
                forceSSL = pro_navidrome.nginx.enable_ssl;
                sslCertificate = "${certDir}/cert.pem";
                sslCertificateKey = "${certDir}/key.pem";
                locations."/" = {
                    proxyPass = "http://localhost:${toString pro_navidrome.port}";
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
