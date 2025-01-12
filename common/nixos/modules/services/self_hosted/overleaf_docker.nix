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
          image = "mono:4.4";
          environment = {
            FERRETDB_HANDLER = "sqlite";
          };
          volumes = [
            "${pro_overleaf.data_dir}-db:/data/db"
          ];
          extraOptions = ["--network=overleaf-net"];
        };

        overleaf = {
          image = "sharelatex:${pro_overleaf.version}";
          environment = let
            redis = "overleaf-redis";
          in {
            SHARELATEX_APP_NAME = "Overleaf (The PropheC)";

            ENABLED_LINKED_FILE_TYPES = "project_file,project_output_file";
            ENABLE_CONVERSIONS = "true";

            SHARELATEX_MONGO_URL = "mongodb://overleaf-db/sharelatex";
            SHARELATEX_REDIS_HOST = redis;
            REDIS_HOST = redis;
          };
          ports = [
            "localhost:${pro_overleaf.port}:80"
          ];
          volumes = [
            "${pro_overleaf.data_dir}-db:/data/db"
          ];
          extraOptions = ["--network=overleaf-net"];
        };
      };
    };
}
