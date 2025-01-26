{
  config,
  lib,
  ...
}: {
  config = let
    pro_dev = config.propheci.dev;
    pro_shells = config.propheci.shells;
  in
    lib.mkIf pro_dev.direnv.enable {
      programs.direnv = {
        enable = true;

        enableBashIntegration = lib.mkIf pro_shells.bash.enable true;
        # Read-only option
        # enableFishIntegration = lib.mkIf pro_shells.fish.enable true;
        enableNushellIntegration = lib.mkIf pro_shells.nushell.enable true;
        enableZshIntegration = lib.mkIf pro_shells.zsh.enable true;
      };
    };
}
