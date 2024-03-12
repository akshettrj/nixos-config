{ config, pkgs, lib, ... }:

{
  programs.bash = {
    enable = true;

    enableVteIntegration = true;
    enableCompletion = true;

    shellAliases = config.shell.aliases;
  };
}
