{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

{
  config =
    let

      pro_editors = config.propheci.programs.editors;

    in
    lib.mkIf pro_editors.zeditor.enable {

      home.packages = [ pkgs.zed-editor ];

    };
}
