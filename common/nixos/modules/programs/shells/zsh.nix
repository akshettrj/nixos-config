{
  config,
  lib,
  ...
}:
{
  config =
    let
      pro_shells = config.propheci.shells;
    in
    lib.mkIf pro_shells.zsh.enable {
      environment.pathsToLink = [ "/share/zsh" ];

      programs.zsh.enable = true;
    };
}
