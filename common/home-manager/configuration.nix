{ config, inputs, lib, pkgs, ... }:

{
    imports = [
        ../../options.nix
        ./modules
    ];

    config = let

        pro_browsers = config.propheci.programs.browsers;
        pro_deskenvs = config.propheci.desktop_environments;
        pro_editors = config.propheci.programs.editors;
        pro_services = config.propheci.services;
        pro_terminals = config.propheci.programs.terminals;
        pro_user = config.propheci.user;

        browsers_meta = import ../metadata/programs/browsers/metadata.nix { inherit pkgs; };
        editors_meta = import ../metadata/programs/editors/metadata.nix { inherit config; inherit inputs; inherit pkgs; };
        terminals_meta = import ../metadata/programs/terminals/metadata.nix { inherit pkgs; };

    in {

        programs.home-manager.enable = true;

        home.username = pro_user.username;
        home.homeDirectory = pro_user.homedir;
        home.stateVersion = "23.11";

        home.sessionVariables = {
            EDITOR = editors_meta."${pro_editors.main}".cmd;
            VISUAL = editors_meta."${pro_editors.main}".cmd;
            SUDO_EDITOR = editors_meta."${pro_editors.main}".cmd;

        } // lib.optionalAttrs pro_terminals.enable {

            TERMINAL = terminals_meta."${pro_terminals.main}".cmd;
            BROWSER = browsers_meta."${pro_browsers.main}".cmd;
        };

        home.packages = with pkgs; [
            btop
            dust
            fd
            nh
            nil
            ripgrep
        ];

        xdg = {
            enable = true;
            userDirs = {
                enable = true;
                createDirectories = true;
                desktop = "${config.home.homeDirectory}/media/desktop";
                documents = "${config.home.homeDirectory}/media/documents";
                download = "${config.home.homeDirectory}/media/downloads";
                music = "${config.home.homeDirectory}/media/music";
                publicShare = "${config.home.homeDirectory}/media/public";
                templates = "${config.home.homeDirectory}/media/templates";
                videos = "${config.home.homeDirectory}/media/videos";
                pictures = "${config.home.homeDirectory}/media/pictures";
            };
            portal = lib.mkIf pro_services.xdg_portal.enable {
                enable = true;
                config.common.default = [ "gtk" ];
                extraPortals = [
                    pkgs.xdg-desktop-portal-gtk
                ] ++ lib.optionals pro_deskenvs.hyprland.enable [
                    (
                        if pro_deskenvs.hyprland.use_official_packages then
                            inputs.hyprland.packages."${pkgs.system}".xdg-desktop-portal-hyprland
                        else
                            pkgs.xdg-desktop-portal-hyprland
                    )
                ];
            };
        };

    };
}
