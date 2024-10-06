{ config, lib, pkgs, ... }:

{
    config = let

        pro_media = config.propheci.programs.media;
        pro_docs = pro_media.documents;

        pro_theming = config.propheci.theming;

    in lib.mkIf (pro_media.enable && pro_docs.zathura.enable) {

        home.packages = [
            (pkgs.zathura.override {
                useMupdf = pro_docs.zathura.useMupdf;
            })
        ];

        xdg.configFile."zathura/zathurarc".text = /*zathurarc*/ ''

set window-title-basename "true"
set selection-clipboard "clipboard"
set adjust-open "best-fit"
set scroll-page-aware "true"
set scroll-full-overlap 0.01
set scroll-step 100
set zoom-min 10
set sandbox "none"
set guioptions ""

set adjust-open width
set recolor true
set render-loading "false"
set scroll-step 50
map R recolor
map <Left> navigate previous
map <Right> navigate next
map <Button8> navigate previous
map <Button9> navigate next

# Theming

set font "${pro_theming.fonts.main.name} ${toString(pro_theming.fonts.main.size)}"

set default-bg                  "#282828"
set default-fg                  "#3c3836"

set statusbar-fg                "#bdae93"
set statusbar-bg                "#504945"

set inputbar-bg                 "#282828"
set inputbar-fg                 "#fbf1c7"

set notification-bg             "#282828"
set notification-fg             "#fbf1c7"

set notification-error-bg       "#282828"
set notification-error-fg       "#fb4934"

set notification-warning-bg     "#282828"
set notification-warning-fg     "#fb4934"

set highlight-color             "#fabd2f"
set highlight-active-color      "#83a598"

set completion-bg               "#3c3836"
set completion-fg               "#83a598"

set completion-highlight-fg     "#fbf1c7"
set completion-highlight-bg     "#83a598"

set recolor-lightcolor          "#282828"
set recolor-darkcolor           "#ebdbb2"

set recolor                     "false"
set recolor-keephue             "false"

        '';

    };
}
