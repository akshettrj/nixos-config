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

    envExtra = ''
      export UNISON="${config.xdg.dataHome}/unison"

      export LESS_TERMCAP_mb=$'\e[1;32m'
      export LESS_TERMCAP_md=$'\e[1;32m'
      export LESS_TERMCAP_me=$'\e[0m'
      export LESS_TERMCAP_se=$'\e[0m'
      export LESS_TERMCAP_so=$'\e[01;33m'
      export LESS_TERMCAP_ue=$'\e[0m'
      export LESS_TERMCAP_us=$'\e[1;4;31m'
    '';
  };
}
