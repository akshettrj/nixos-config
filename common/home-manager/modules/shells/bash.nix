{ config, lib, pkgs, ... }:

{
    config = let

        pro_shells = config.propheci.shells;
        pro_file_explorers = config.propheci.programs.file_explorers;

    in lib.mkIf pro_shells.bash.enable {

        programs.bash = {
            enable = true;

            enableVteIntegration = true;
            enableCompletion = true;

            historyControl = ["erasedups" "ignorespace"];
            historyFile = "$HOME/.cache/bash_history";
            historyIgnore = [
                "reboot*"
                "shutdown*"
                ". *"
            ] ++ lib.optionals pro_shells.zoxide.enable [
                "z"
                "z *"
                "zi"
                "zi *"
            ];
            historySize = 10000;

            initExtra = ''
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

            '';
        };

    };

}
