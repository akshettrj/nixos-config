{ config, lib, pkgs, ... }:

{
    config = let

        pro_dev = config.propheci.dev;

    in lib.mkIf pro_dev.git.enable {

        programs.git = {
            enable = true;
            userName = pro_dev.git.user.name;
            userEmail = pro_dev.git.user.email;
            delta.enable = pro_dev.git.delta.enable;
            extraConfig = {
                init.defaultBranch = pro_dev.git.default_branch;
            };
        };

        home.packages = [ pkgs.gitu ];

    };
}
