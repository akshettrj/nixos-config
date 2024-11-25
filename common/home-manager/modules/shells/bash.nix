{
  config,
  lib,
  pkgs,
  ...
}:

{
  config =
    let

      pro_shells = config.propheci.shells;
      pro_file_explorers = config.propheci.programs.file_explorers;

    in
    lib.mkIf pro_shells.bash.enable {

      programs.bash = {
        enable = true;

        enableVteIntegration = true;
        enableCompletion = true;

        historyControl = [
          "erasedups"
          "ignorespace"
        ];
        historyFile = "$HOME/.cache/bash_history";
        historyIgnore = (import ./history_ignore_patterns.nix);
        historySize = 10000;

        initExtra =
          ''''
          +
            lib.optionalString pro_file_explorers.lf.enable # sh
              ''

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
