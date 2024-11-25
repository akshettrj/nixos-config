{ config, lib, ... }:

{
  config =
    let

      pro_ss_tools = config.propheci.programs.screenshot_tools;

      ss_dir = "${config.xdg.userDirs.pictures}/screenshots";

    in
    lib.mkIf pro_ss_tools.enable {

      # Make the screenshots directory
      home.activation.createScreenshotsDirectory =
        lib.hm.dag.entryAfter [ "writeBoundary" ] # sh
          ''
            [[ -L "${ss_dir}" ]] || run mkdir -p $VERBOSE_ARG "${ss_dir}"
          '';

    };
}
