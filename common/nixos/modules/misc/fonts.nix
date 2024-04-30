{
  config,
  lib,
  pkgs,
  ...
}:

{
  config =
    let

      pro_theming = config.propheci.theming;
    in
    lib.mkIf pro_theming.enable {

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
    };
}
