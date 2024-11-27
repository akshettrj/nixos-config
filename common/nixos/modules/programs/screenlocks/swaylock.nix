{
  config,
  lib,
  ...
}: {
  config = let
    pro_screenlocks = config.propheci.programs.screenlocks;
  in
    lib.mkIf (pro_screenlocks.enable && pro_screenlocks.swaylock.enable) {
      security.pam.services.swaylock = {};
    };
}
