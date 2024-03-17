{ lib, config, pkgs, ... }:

{
  options = let
  inherit (lib) mkOption types;
  in {
    fontconfig.enable = mkOption { type = types.bool; example = true; };
  };

  config = lib.mkIf config.fontconfig.enable {
    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        monospace = [ "Iosevka NF" ];
        sansSerif = [ "Iosevka NF" ];
        serif = [ "Iosevka NF" ];
      };
      localConf = ''
      <fontconfig>
        <match target="pattern">
          <test qual="any" name="family"><string>monospace</string></test>
          <edit name="family" mode="assign" binding="same"><string>Iosevka NF</string></edit>
          <edit name="family" mode="append" binding="weak"><string>JetBrainsMono NF</string></edit>
        </match>

        <match target="pattern">
          <test qual="any" name="family"><string>ui-monospace</string></test>
          <edit name="family" mode="assign" binding="same"><string>Iosevka NF</string></edit>
          <edit name="family" mode="append" binding="weak"><string>JetBrainsMono NFM</string></edit>
        </match>

        <match target="pattern">
          <test qual="any" name="family"><string>serif</string></test>
          <edit name="family" mode="assign" binding="same"><string>Iosevka NF</string></edit>
          <edit name="family" mode="append" binding="weak"><string>JetBrainsMono NFM</string></edit>
          <edit name="family" mode="append" binding="weak"><string>Noto Serif</string></edit>
        </match>

        <match target="pattern">
          <test qual="any" name="family"><string>sans-serif</string></test>
          <edit name="family" mode="assign" binding="same"><string>Iosevka NF</string></edit>
          <edit name="family" mode="append" binding="weak"><string>JetBrainsMono NFM</string></edit>
          <edit name="family" mode="append" binding="weak"><string>Noto Serif</string></edit>
        </match>

        <match target="pattern">
          <test qual="any" name="family"><string>emoji</string></test>
          <edit name="family" mode="assign" binding="same"><string>Noto Color Emoji</string></edit>
        </match>
      </fontconfig>
      '';
    };
  };
}
