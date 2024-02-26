{ config, pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;

    dotDir = ".config/zsh";

    enableAutosuggestions = true;
    enableCompletion = true;

    defaultKeymap = "viins";

    history = {
      path = "$HOME/.cache/zsh_history";
      expireDuplicatesFirst = true;
      extended = true;
      ignoreDups = true;
      ignoreAllDups = true;
      ignorePatterns = ["reboot*" "shutdown*"];
      ignoreSpace = true;
      save = 10000;
      share = true;
      size = 10000;
    };

    syntaxHighlighting = {
      enable = true;
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
  };
}
