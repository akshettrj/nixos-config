{
  config,
  inputs,
  lib,
  nixpkgs,
  pkgs,
  ...
}:

{
  config =
    let

      pro_editors = config.propheci.programs.editors;
    in
    lib.mkIf pro_editors.neovim.enable {

      programs.neovim = {
        enable = true;
        defaultEditor = if pro_editors.main == "neovim" then true else false;
      };

      environment.systemPackages = [ pkgs.neovim ];
    };
}
