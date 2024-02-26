{ config, pkgs, inputs, lib, ... }:

{
  imports = [
    ../modules/display-managers/hyprland.nix
    ../modules/launchers/bemenu.nix
    ../modules/shells/zsh.nix
    ../modules/shells/starship.nix
    ../modules/file_explorers/lf.nix
  ];

  options = let
    inherit (lib) mkOption mkEnableOption types;
    known_terminals = ["wezterm" "alacritty"];
    known_editors = ["neovim" "helix"];
  in {
    username = mkOption {
      type = types.str;
      example = "akshettrj";
      description = ''
        The username for the main user
      '';
    };

    homedirectory = mkOption {
      type = types.str;
      example = "/home/akshettrj";
      description = ''
        The home directory for the main user
      '';
    };

    hasDisplay = mkEnableOption("Set to true if system has a display");

    editors = {
      main = mkOption {
        type = types.enum(known_editors);
        example = "neovim";
        description = ''
          The main editor
        '';
      };
      backup = mkOption {
        type = types.enum(known_editors);
        example = "helix";
        description = ''
          The backup editor
        '';
      };
    };

    terminals = {
      enable = mkEnableOption("Enable terminals");
      main = mkOption {
        type = types.enum(known_terminals);
        example = "wezterm";
        description = ''
          The main terminal
        '';
      };
      backup = mkOption {
        type = types.enum(known_terminals);
        example = "alacritty";
        description = ''
          The backup terminal
        '';
      };
    };
  };

  config = let
    terminal_configs = {
      "alacritty" = rec {
        package = pkgs.alacritty;
        binary = "${package}/bin/alacritty";
        command = "${package}/bin/alacritty";
      };
      "wezterm" = rec {
        package = pkgs.wezterm;
        binary = "${package}/bin/wezterm";
        command = "${package}/bin/wezterm start --always-new-process";
      };
    };

    editor_configs = {
      "neovim" = rec {
        package = pkgs.neovim;
        binary = "${package}/bin/nvim";
        command = "${package}/bin/nvim";
      };
      "helix" = rec {
        package = pkgs.helix;
        binary = "${package}/bin/hx";
        command = "${package}/bin/hx";
      };
    };

    editors = {
      main = editor_configs."${config.editors.main}";
      backup = editor_configs."${config.editors.backup}";
    };

    terminals = lib.mkIf config.terminals.enable {
      main = terminal_configs."${config.terminals.main}";
      backup = terminal_configs."${config.terminals.backup}";
    };

  in {

    home.username = "${config.username}";
    home.homeDirectory = "${config.homedirectory}";

    home.stateVersion = "23.11"; # Please read the comment before changing.

    home.packages = [
      (pkgs.nerdfonts.override { fonts = [ "Iosevka" ]; })

      pkgs.btop
      pkgs.ripgrep

      editors.main.package
      editors.backup.package

    ] ++ lib.optionals config.terminals.enable [
      terminals.main.package
      terminals.backup.package
    ];

    home.file = {
    #   # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    #   # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    #   # # symlink to the Nix store copy.
    #   # ".screenrc".source = dotfiles/screenrc;

    #   # # You can also set the file content immediately.
    #   # ".gradle/gradle.properties".text = ''
    #   #   org.gradle.console=verbose
    #   #   org.gradle.daemon.idletimeout=3600000
    #   # '';
    };

    # Home Manager can also manage your environment variables through
    # 'home.sessionVariables'. If you don't want to manage your shell through Home
    # Manager then you have to manually source 'hm-session-vars.sh' located at
    # either
    #
    #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  /etc/profiles/per-user/akshettrj/etc/profile.d/hm-session-vars.sh
    #
    home.sessionVariables = {
      EDITOR = "${editors.main.binary}";
      VISUAL = "${editors.main.binary}";
    } // lib.optionalAttrs config.terminals.enable {
      TERMINAL = "${terminals.main.binary}";
    };

    programs.git = {
      enable = true;
      userName = "Akshett Rai Jindal";
      userEmail = "jindalakshett@gmail.com";
    };

    hyprland = lib.mkIf config.hyprland.enable {
      terminalCommand = terminals.main.command;
      backupTerminalCommand = terminals.backup.command;
      terminalCommandExecutor = "${terminals.main.binary} -e";
      backupTerminalCommandExecutor = "${terminals.backup.binary} -e";
    };

    programs.bash = {
      enable = true;
    };

    programs.home-manager.enable = true;
  };
}
