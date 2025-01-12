{
  config,
  lib,
  ...
}: {
  config = let
    pro_user = config.propheci.user;
    pro_virtualisation = config.propheci.services.virtualisation;
  in lib.mkIf pro_virtualisation.enable {

    users.users."${pro_user.username}".extraGroups = ["docker"];

    virtualisation.docker = lib.mkIf pro_virtualisation.docker.enable {
      enable = true;
      rootless.enable = pro_virtualisation.docker.rootless;
    };

    virtualisation.oci-containers = lib.mkIf pro_virtualisation.containers.enable {
      backend = pro_virtualisation.containers.backend;
    };

  };

}
