{
  config,
  lib,
  pkgs,
  ...
}:

{
  config =
    let

      pro_dev = config.propheci.dev;

    in
    lib.mkIf pro_dev.cachix.enable {

      home.packages = [ pkgs.cachix ];

    };
}
