{ config, ... }:

{
  imports = [
    ./bash.nix
    ./fish.nix
    ./nushell.nix
    ./zsh.nix

    ./utils
  ];

  config =
    let

      pro_shells = config.propheci.shells;
    in
    {

      home.shellAliases = pro_shells.aliases;
    };
}
