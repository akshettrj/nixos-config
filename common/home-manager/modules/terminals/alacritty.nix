{ config, lib, ... }:

{
    config = let

        pro_terminals = config.propheci.programs.terminals;
        pro_theming = config.propheci.theming;

    in lib.mkIf (pro_terminals.enable && pro_terminals.alacritty.enable) {

        programs.alacritty = {
            enable = true;

            settings = {
                colors = {
                    draw_bold_text_with_bright_colors = true;
                    bright = {
                        black = "#928374";
                        blue = "#83a598";
                        cyan = "#8ec07c";
                        green = "#b8bb26";
                        magenta = "#d3869b";
                        red = "#fb4934";
                        white = "#ebdbb2";
                        yellow = "#fabd2f";
                    };
                    normal = {
                        black = "#282828";
                        blue = "#458588";
                        cyan = "#689d6a";
                        green = "#98971a";
                        magenta = "#b16286";
                        red = "#cc241d";
                        white = "#a89984";
                        yellow = "#d79921";
                    };
                    primary = {
                        background = "#282828";
                        foreground = "#ebdbb2";
                    };
                };
                cursor = {
                    style = "Beam";
                    vi_mode_style = "Block";
                };
                debug = {
                    log_level = "Warn";
                    persistent_logging = false;
                    print_events = false;
                    render_timer = false;
                };
                font = {
                    size = pro_terminals.alacritty.font_size;
                    bold = {
                        family = pro_theming.fonts.main.name;
                        style = "Bold";
                    };
                    bold_italic = {
                        family = pro_theming.fonts.main.name;
                        style = "Bold Italic";
                    };
                    italic = {
                        family = pro_theming.fonts.main.name;
                        style = "Italic";
                    };
                    normal = {
                        family = pro_theming.fonts.main.name;
                        style = "Regular";
                    };
                    offset = {
                        x = 0;
                        y = -1;
                    };
                };
                hints = {
                    enabled = [{
                        command = "xdg-open";
                        post_processing = true;
                        regex = ''(ipfs:|ipns:|magnet:|mailto:|gemini:|gopher:|https:|http:|news:|file:|git:|ssh:|ftp:|git@github.com:)[^\u0000-\u001F\u007F-<>"\\s{-}\\^⟨⟩`]+'';
                        binding = {
                            key = "U";
                            mods = "Control|Shift";
                        };
                        mouse = {
                            enabled = true;
                            mods = "None";
                        };
                    }];
                };
                mouse = {
                    hide_when_typing = true;
                    bindings = [{
                        action = "Copy";
                        mouse = "Middle";
                    }];
                };
                selection = {
                    semantic_escape_chars = '',│`|:"' ()[]{}<>\t'';
                };
                window = {
                    decorations = "none";
                    dynamic_padding = true;
                    dynamic_title = true;
                    startup_mode = "Windowed";
                    class = {
                        general = "Alacritty";
                        instance = "alacritty";
                    };
                    padding = {
                        x = 2;
                        y = 2;
                    };
                    opacity = 0.9;
                };
                keyboard.bindings = [
                    {
                        action = "Copy";
                        key = "Y";
                        mods = "Alt";
                    }
                    {
                        action = "SpawnNewInstance";
                        key = 28;
                        mods = "Alt";
                    }
                    {
                        action = "IncreaseFontSize";
                        key = 13;
                        mods = "Alt";
                    }
                    {
                        action = "DecreaseFontSize";
                        key = 12;
                        mods = "Alt";
                    }
                ];
            };
        };

    };
}
