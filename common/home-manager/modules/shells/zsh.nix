{ config, lib, pkgs, ... }:

{
    config = let

        pro_shells = config.propheci.shells;
        pro_file_explorers = config.propheci.programs.file_explorers;

    in lib.mkIf pro_shells.zsh.enable {

        programs.zsh = {
            enable = true;

            dotDir = ".config/zsh";

            enableVteIntegration = true;
            autosuggestion.enable = true;
            enableCompletion = true;

            history = {
                path = "$HOME/.cache/zsh_history";
                expireDuplicatesFirst = true;
                extended = true;
                ignoreDups = true;
                ignoreAllDups = true;
                ignorePatterns = (import ./history_ignore_patterns.nix);
                ignoreSpace = true;
                save = 10000;
                share = true;
                size = 10000;
            };

            syntaxHighlighting = {
                enable = true;
                highlighters = [ "brackets" "pattern" "root" "line" ];
            };

            plugins = [
                {
                    name = "git";
                    file = "plugins/git/git.plugin.zsh";
                    src = pkgs.fetchFromGitHub {
                        owner = "ohmyzsh";
                        repo = "ohmyzsh";
                        rev = "40ff950fcd081078a8cd3de0eaab784f85c681d5";
                        sha256 = "sha256-EJ/QGmfgav0DVQFSwT+1FjOwl0S28wvJAghxzVAeJbs=";
                    };
                }
            ];

            envExtra = "";

            initExtraFirst = ''
                setopt HIST_REDUCE_BLANKS
                setopt COMPLETE_ALIASES
            '';

            initExtraBeforeCompInit = "";

            initExtra = ''
                # Tab Completion
                zmodload zsh/complist

                zstyle ':completion:*' menu select
                zstyle ':completion:*' matcher-list ''' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=*r:|=*'
                zstyle ':completion:*' special-dirs false
                zstyle ':completion::complete:*' gain-privileges 1

                zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
                zstyle ':completion:*:descriptions' format "%F{yellow}%B-- %d --%f%b"
                zstyle ':completion:*:messages' format '%d'
                zstyle ':completion:*:warnings' format "%F{red}%BNo matches for:%b%f %d"
                zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
                zstyle ':completion:*' group-name '''
                zstyle ':completion:*' squeeze-slashes true

                # Shift + Tab to go back
                bindkey -M menuselect '^[[Z' reverse-menu-complete

                _comp_options+=(globdots)

                ###################################################

                # Vim mode
                bindkey -v
                export KEYTIMEOUT=1

                # Edit command in vim buffer
                autoload edit-command-line && zle -N edit-command-line
                bindkey '^v' edit-command-line
                bindkey -M vicmd '^v' edit-command-line

                # Vim keybindings in tab complete menu
                bindkey -M menuselect 'h' vi-backward-char
                bindkey -M menuselect 'j' vi-down-line-or-history
                bindkey -M menuselect 'k' vi-up-line-or-history
                bindkey -M menuselect 'l' vi-forward-char
                bindkey -M menuselect 'left' vi-backward-char
                bindkey -M menuselect 'down' vi-down-line-or-history
                bindkey -M menuselect 'up' vi-up-line-or-history
                bindkey -M menuselect 'right' vi-forward-char

                # Fix backspace bug after switching modes
                bindkey '^?' backward-delete-char

                # Change cursor shape for different modes
                function zle-keymap-select {
                    case $KEYMAP in
                        vicmd) echo -n '\e[1 q';;
                        viins|main) echo -n '\e[5 q';;
                    esac
                }
                zle -N zle-keymap-select

                # ci", ci', ci`, di", etc
                autoload -U select-quoted && zle -N select-quoted
                for m in visual viopp
                do
                    for c in {a,i}{\',\",\`}
                    do
                        bindkey -M $m $c select-quoted
                    done
                done

                # ci(, ci{, ci<, di(, etc
                autoload -U select-bracketed && zle -N select-bracketed
                for m in visual viopp
                do
                    for c in {a,i}''${(s..)^:-'()[]{}<>bB'}
                    do
                        bindkey -M $m $c select-bracketed
                    done
                done

                # Set default mode and cursor
                zle-line-init() {
                    zle -K viins
                    echo -ne '\e[5 q'
                }
                zle -N zle-line-init
                preexec() {
                    echo -ne '\e[5 q'
                }

            '' + lib.optionals pro_file_explorers.lf.enable ''

                ###################################################

                # LFCD
                function lfcd() {
                    tmp="$(mktemp)"
                    ${pkgs.lf}/bin/lf -last-dir-path="$tmp" "$@"
                    if [ -f "$tmp" ]; then
                        dir="$(cat "$tmp")"
                        rm -f "$tmp" >/dev/null
                        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
                    fi
                }

            '' + lib.optionals pro_file_explorers.yazi.enable ''

                ###################################################

                # YaziCD
                function yazicd() {
                    tmp="$(mktemp)"
                    ${pkgs.yazi}/bin/yazi --cwd-file="$tmp" "$@"
                    if [ -f "$tmp" ]; then
                        dir="$(cat "$tmp")"
                        rm -f "$tmp" >/dev/null
                        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
                    fi
                }

            '' + ''
                bindkey -s '^o' "${if pro_file_explorers.main == "lf" then "lfcd" else "yazicd"}\n"
            '';
        };

    };
}
