{
  config,
  lib,
  ...
}: {
  config = let
    pro_services = config.propheci.services;
  in
    lib.mkIf pro_services.tailscale.enable {
      services.tailscale = {
        enable = true;
        useRoutingFeatures = "both";
      };
    };
}
