{
  config,
  lib,
  ...
}: {
  config = let
    pro_shells = config.propheci.shells;
  in
    lib.mkIf pro_shells.eza.enable {
      programs.eza = {
        enable = true;
        enableBashIntegration = lib.mkIf pro_shells.bash.enable true;
        enableFishIntegration = lib.mkIf pro_shells.fish.enable true;
        enableNushellIntegration = lib.mkIf pro_shells.nushell.enable true;
        enableZshIntegration = lib.mkIf pro_shells.zsh.enable true;
        git = true;
        icons = "auto";
      };
    };
}
