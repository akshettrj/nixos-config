{
  config,
  lib,
  ...
}: {
  config = let
    pro_adguard = config.propheci.services.self_hosted.adguard;
  in
    lib.mkIf pro_adguard.enable {
      services.adguardhome = {
        enable = true;
        mutableSettings = true;
        openFirewall = pro_adguard.open_firewall;
        port = pro_adguard.port;
      };

      services.nginx = lib.mkIf pro_adguard.nginx.enable rec {
        virtualHosts = {
          "${pro_adguard.nginx.hostname}" = let
            certDir = config.security.acme.certs."${pro_adguard.nginx.hostname}".directory;
          in {
            forceSSL = pro_adguard.nginx.enable_ssl;
            sslCertificate = "${certDir}/cert.pem";
            sslCertificateKey = "${certDir}/key.pem";
            locations."/" = {
              proxyPass = "http://localhost:${toString pro_adguard.port}";
              extraConfig = ''
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection 'upgrade';
                proxy_set_header Host $host;
                proxy_cache_bypass $http_upgrade;
              '';
            };
          };
          "*.${pro_adguard.nginx.hostname}" = virtualHosts."${pro_adguard.nginx.hostname}";
        };
      };

      networking.firewall.allowedTCPPorts = [
        853
        53
      ];
      networking.firewall.allowedUDPPorts = [
        853
        53
      ];
    };
}
