{ config, lib, ... }:

{
  config =
    let

      pro_hw = config.propheci.hardware;
    in
    lib.mkIf pro_hw.bluetooth.enable {

      xdg.configFile."bluetuith/bluetuith.conf".text = ''

        {
            "keybindings": {
                NavigateUp: 'k',
                NavigateDown: 'j',
                NavigateRight: 'l',
                NavigateLeft: 'h',
                Quit: 'q',
            }
        }

      '';
    };
}
