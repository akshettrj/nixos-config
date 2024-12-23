{
  config,
  lib,
  ...
}:
{
  config =
    let
      pro_theming = config.propheci.theming;
    in
    lib.mkIf (pro_theming.enable && pro_theming.gtk) {
      programs.dconf.enable = true;
    };
}
