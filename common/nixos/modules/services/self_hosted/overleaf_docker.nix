{
  config,
  inputs,
  lib,
  ...
}: {
  config = let
    pro_nginx = config.propheci.services.nginx;
    pro_overleaf = config.propheci.services.self_hosted.overleaf;
  in
    lib.mkIf pro_overleaf.enable {
      assertions = [
        {
          assertion =
            if pro_overleaf.nginx.enable
            then pro_nginx.enable
            else true;
          message = "Vikunja's nginx is enabled, but global nginx is not";
        }
      ];

      systemd.services.docker-network-overleaf = inputs.rubikoid_base.lib.r.mkDockerNet config "overleaf";

      virtualisation.oci-containers.containers = {
        overleaf-redis = {
          image = "redis";
          volumes = [
            "${pro_overleaf.data_dir}-redis:/data"
          ];
          extraOptions = ["--network=overleaf-net"];
        };

        overleaf-db = {
          image = "mongo:5.0.31-rc0";
          cmd = ["--replSet" "rs0"];
          environment = {
            FERRETDB_HANDLER = "sqlite";
          };
          volumes = [
            "${pro_overleaf.data_dir}-db:/data/db"
          ];
          extraOptions = ["--network=overleaf-net"];
        };

        overleaf = {
          image = "sharelatex/sharelatex:${pro_overleaf.version}";
          environment = let
            redis = "overleaf-redis";
          in {
            OVERLEAF_APP_NAME = "Overleaf (The PropheC)";

            ENABLED_LINKED_FILE_TYPES = "project_file,project_output_file";
            ENABLE_CONVERSIONS = "true";

            OVERLEAF_MONGO_URL = "mongodb://overleaf-db/overleaf";
            OVERLEAF_REDIS_HOST = redis;
            REDIS_HOST = redis;
          };
          ports = [
            "${toString pro_overleaf.port}:80"
          ];
          volumes = [
            "${pro_overleaf.data_dir}:/var/lib/overleaf"
          ];
          extraOptions = ["--network=overleaf-net"];
        };
      };

      services.nginx = lib.mkIf pro_overleaf.nginx.enable {
        virtualHosts."${pro_overleaf.nginx.hostname}" = let
          certDir = config.security.acme.certs."${pro_overleaf.hostname}".directory;
        in {
          forceSSL = pro_overleaf.nginx.enable_ssl;
          sslCertificate = "${certDir}/cert.pem";
          sslCertificateKey = "${certDir}/key.pem";
          locations."/" = {
            proxyPass = "http://localhost:${toString pro_overleaf.port}";
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
