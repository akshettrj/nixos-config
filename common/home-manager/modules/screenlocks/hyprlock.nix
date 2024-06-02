{ config, inputs, lib, pkgs, ... }:

{
    config = let

        pro_deskenvs = config.propheci.desktop_environments;
        pro_theming = config.propheci.theming;

        screenlocks_meta = import ../../../metadata/programs/screenlocks/metadata.nix { inherit config; inherit inputs; inherit pkgs; };

    in lib.mkIf pro_deskenvs.screenlocks.hyprlock.enable {

        xdg.configFile."hypr/hyprlock.conf".text = ''

        general {
            disable_loading_bar = false
            hide_cursor = false
            grace = 2
            no_fade_in = false
            no_fade_out = false
            ignore_empty_input = true
            pam_module = hyprlock
        }

        background {
            path = ${pro_deskenvs.screenlocks.hyprlock.background_image}
            blur_passes = 3
            blur_size = 7
        }

        input-field {
            size = 250, 60
            outline_thickness = 2
            shadow_passes = 3
            shadow_size = 3
            shadow_boost = 1.5
            halign = center
            valign = center
            position = 0, -120
        }

        '';

        home.packages = [ screenlocks_meta.hyprlock.pkg ];

    };
}
