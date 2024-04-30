{ config, lib, pkgs, ... }:

{
    config = let

        pro_theming = config.propheci.theming;

    in lib.mkIf pro_theming.enable {

        fonts.packages = with pkgs; [
            (nerdfonts.override { fonts = pro_theming.fonts.nerdfonts; })

            noto-fonts
            noto-fonts-cjk-sans
            noto-fonts-cjk-serif
            noto-fonts-color-emoji

            lohit-fonts.assamese
            lohit-fonts.kannada
            lohit-fonts.marathi
            lohit-fonts.tamil
            lohit-fonts.bengali
            lohit-fonts.kashmiri
            lohit-fonts.nepali
            lohit-fonts.tamil-classical
            lohit-fonts.devanagari
            lohit-fonts.konkani
            lohit-fonts.odia
            lohit-fonts.telugu
            lohit-fonts.gujarati
            lohit-fonts.maithili
            lohit-fonts.gurmukhi
            lohit-fonts.malayalam
            lohit-fonts.sindhi

            unifont
            liberation_ttf
        ];

        fonts.fontconfig = {
            enable = true;
            defaultFonts = {
                emoji = [ "Noto Color Emoji" ];
                monospace = [ "${pro_theming.fonts.main.name}" ];
                sansSerif = [ "${pro_theming.fonts.main.name}" ];
                serif = [ "${pro_theming.fonts.main.name}" ];
            };
            localConf = ''
                <fontconfig>
                <match target="pattern">
                <test qual="any" name="family"><string>monospace</string></test>
                <edit name="family" mode="assign" binding="same"><string>${pro_theming.fonts.main.name}</string></edit>
                <edit name="family" mode="append" binding="weak"><string>${(builtins.elemAt pro_theming.fonts.backups 0).name}</string></edit>
                </match>

                <match target="pattern">
                <test qual="any" name="family"><string>ui-monospace</string></test>
                <edit name="family" mode="assign" binding="same"><string>${pro_theming.fonts.main.name}</string></edit>
                <edit name="family" mode="append" binding="weak"><string>${(builtins.elemAt pro_theming.fonts.backups 0).name}M</string></edit>
                </match>

                <match target="pattern">
                <test qual="any" name="family"><string>serif</string></test>
                <edit name="family" mode="assign" binding="same"><string>${pro_theming.fonts.main.name}</string></edit>
                <edit name="family" mode="append" binding="weak"><string>${(builtins.elemAt pro_theming.fonts.backups 0).name}M</string></edit>
                <edit name="family" mode="append" binding="weak"><string>Noto Serif</string></edit>
                </match>

                <match target="pattern">
                <test qual="any" name="family"><string>sans-serif</string></test>
                <edit name="family" mode="assign" binding="same"><string>${pro_theming.fonts.main.name}</string></edit>
                <edit name="family" mode="append" binding="weak"><string>${(builtins.elemAt pro_theming.fonts.backups 0).name}M</string></edit>
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
