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
    known_browsers = ["brave" "chrome" "firefox" "chromium"];
  in {
    username = mkOption { type = types.str; example = "akshettrj"; };

    homedirectory = mkOption { type = types.str; example = "/home/akshettrj"; };

    editors = {
      main = mkOption { type = types.enum(known_editors); example = "neovim"; };
      backup = mkOption { type = types.enum(known_editors); example = "helix"; };
    };

    terminals = {
      enable = mkEnableOption("Enable terminals");

      main = mkOption { type = types.enum(known_terminals); example = "wezterm"; };
      backup = mkOption { type = types.enum(known_terminals); example = "alacritty"; };
    };

    browsers = {
      main = mkOption { type = types.enum(known_browsers); example = "brave"; };
      backups = mkOption { type = types.listOf(types.enum(known_browsers)); example = ["firefox" "chrome"]; };
    };

    hasDisplay = mkEnableOption("Enable if has display");
  };

  config = let
    terminal_configs = {
      "alacritty" = rec { package = pkgs.alacritty; binary = "${package}/bin/alacritty"; command = "${package}/bin/alacritty"; };
      "wezterm" = rec { package = pkgs.wezterm; binary = "${package}/bin/wezterm"; command = "${package}/bin/wezterm start --always-new-process"; };
    };

    editor_configs = {
      "neovim" = rec { package = pkgs.neovim; binary = "${package}/bin/nvim"; command = "${package}/bin/nvim"; };
      "helix" = rec { package = pkgs.helix; binary = "${package}/bin/hx"; command = "${package}/bin/hx"; };
    };

    browser_configs = {
      "brave" = rec { package = pkgs.brave; binary = "${package}/bin/brave"; command = "${binary}"; };
      "chrome" = rec { package = pkgs.google-chrome; binary = "${package}/bin/google-chrome-stable"; command = "${binary}"; };
      "firefox" = rec { package = pkgs.firefox; binary = "${package}/bin/firefox"; command = "${binary}"; };
      "chromium" = rec { package = pkgs.chromium; binary = "${package}/bin/chromium"; command = "${binary}"; };
    };

    editors = {
      main = editor_configs."${config.editors.main}";
      backup = editor_configs."${config.editors.backup}";
    };

    terminals = {
      main = terminal_configs."${config.terminals.main}";
      backup = terminal_configs."${config.terminals.backup}";
    };

    browsers = {
      main = browser_configs."${config.browsers.main}";
      backups = map(b: browser_configs."${b}")(config.browsers.backups);
    };

  in {

    home.username = "${config.username}";
    home.homeDirectory = "${config.homedirectory}";

    home.stateVersion = "23.11"; # Please read the comment before changing.

    home.packages = [

      pkgs.btop
      pkgs.ripgrep

    ] ++ lib.optionals config.hasDisplay(
      [

        (pkgs.nerdfonts.override { fonts = [ "Iosevka" "JetBrainsMono" ]; })

        terminals.main.package
        terminals.backup.package

        browsers.main.package

        pkgs.telegram-desktop

        pkgs.lohit-fonts.assamese
        pkgs.lohit-fonts.kannada
        pkgs.lohit-fonts.marathi
        pkgs.lohit-fonts.tamil
        pkgs.lohit-fonts.bengali
        pkgs.lohit-fonts.kashmiri
        pkgs.lohit-fonts.nepali
        pkgs.lohit-fonts.tamil-classical
        pkgs.lohit-fonts.devanagari
        pkgs.lohit-fonts.konkani
        pkgs.lohit-fonts.odia
        pkgs.lohit-fonts.telugu
        pkgs.lohit-fonts.gujarati
        pkgs.lohit-fonts.maithili
        pkgs.lohit-fonts.gurmukhi
        pkgs.lohit-fonts.malayalam
        pkgs.lohit-fonts.sindhi

      ] ++ map(b: b.package)(browsers.backups)
    );

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
      UNISON = "${config.xdg.dataHome}/unison";

      EDITOR = "${editors.main.binary}";
      VISUAL = "${editors.main.binary}";
      SUDO_EDITOR = "${editors.main.binary}";
    } // lib.optionalAttrs config.hasDisplay {
      TERMINAL = "${terminals.main.binary}";
      BROWSER = "${browsers.main.binary}";
    };

    xdg = {
      enable = true;
      userDirs = {
        enable = true;
        createDirectories = true;
        desktop = "${config.home.homeDirectory}/media/desktop";
        documents = "${config.home.homeDirectory}/media/documents";
        download = "${config.home.homeDirectory}/media/downloads";
        music = "${config.home.homeDirectory}/media/music";
        publicShare = "${config.home.homeDirectory}/media/public";
        templates = "${config.home.homeDirectory}/media/templates";
        videos = "${config.home.homeDirectory}/media/videos";
        pictures = "${config.home.homeDirectory}/media/pictures";
      };
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
