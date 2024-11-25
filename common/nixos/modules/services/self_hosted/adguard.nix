{ config, lib, ... }:

{
  config =
    let

      pro_adguard = config.propheci.services.self_hosted.adguard;

    in
    lib.mkIf pro_adguard.enable {

      services.adguardhome = {
        enable = true;
        mutableSettings = true;
        openFirewall = pro_adguard.open_firewall;
        port = pro_adguard.port;
      };

      networking.firewall.allowedTCPPorts = [
        443
        853
        53
        80
      ];
      networking.firewall.allowedUDPPorts = [
        443
        853
        53
      ];

    };
}
