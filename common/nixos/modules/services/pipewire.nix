{ pkgs, lib, config, ... }:

{
    config = let

        pro_services = config.propheci.services;

    in lib.mkIf pro_services.pipewire.enable {

        security.rtkit.enable = true;

        services.pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            audio.enable = true;
            pulse.enable = true;
        };

        environment.systemPackages = [ pkgs.pulsemixer ];

    };
}
