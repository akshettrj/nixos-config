{
  config,
  pkgs,
  lib,
  ...
}:

{
  config =
    let

      pro_shells = config.propheci.shells;

      shells_meta = import ../../../metadata/programs/shells/metadata.nix { inherit pkgs; };
    in
    lib.mkIf config.propheci.programs.file_explorers.lf.enable {

      programs.lf = {
        enable = true;
        settings = {
          shell = shells_meta."${pro_shells.main}".bin;
          shellopts = "-euy";
          hidden = true;
          ifs = "\\n";
          number = true;
          relativenumber = true;
          icons = true;
          preview = true;
          drawbox = true;
        };
        keybindings = {
          "<enter>" = "shell";
          x = ''''$"$f"'';
          X = ''!"$f"'';
          J = '':updir; set dironly true; down; set dironly false; open'';
          K = '':updir; set dironly true; up; set dironly false; open'';
          DD = "delete";
        };
        commands =
          {
            # Basics
            mkdir = ''%mkdir "$@"'';
            touch = ''%touch "$@"'';
          }
          // lib.optionalAttrs config.propheci.programs.zoxide.enable {

            # Zoxide
            z = ''
              %{{
                  result="$(${pkgs.zoxide}/bin/zoxide query --exclude $PWD $@)"
                  lf -remote "send $id cd $result"
              }}
            '';
            zi = ''
              ''${{
                  result="$(zoxide query -i)"
                  lf -remote "send $id cd $result"
              }}
            '';
          };
        extraConfig = ''
          %[ $LF_LEVEL -eq 1 ] || echo "Warning: You're in a nested lf instance! [LEVEL $LF_LEVEL]"
        '';
      };
    };
}
