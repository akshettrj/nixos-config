{ config, lib, pkgs, ... }:

{
  imports = [];

  options = let
    inherit (lib) mkOption mkEnableOption types;
  in {

    username = mkOption { type = types.str; example = "akshettrj"; };

    sudoWithoutPassword.enable = mkEnableOption("Allow user to run sudo commands without password");

    timezone = mkOption { type = types.str; example = "Asia/Kolkata"; };

    hostname = mkOption { type = types.str; };

    bluetooth.enable = mkEnableOption("Enable bluetooth");

    printing.enable = mkEnableOption("Enable CUPS printing");

    firewall = {
      enable = mkEnableOption("Enable firewall");
      tcpPorts = mkOption { type = types.listOf(types.port); example = [22]; };
      udpPorts = mkOption { type = types.listOf(types.port); example = []; };
    };

    pipewire.enable = mkEnableOption("Enable pipewire");

    garbageCollection.enable = mkEnableOption("Enable automatic garbage collection");

    openssh = {
      enable = mkEnableOption("Enable OpenSSH server");
      ports = mkOption { type = types.listOf(types.port); example = [22 993]; };
      passwordAuthentication = mkOption { type = types.bool; example = true; };
      rootLogin = mkOption { type = types.enum(["yes" "without-password" "prohibit-password" "forced-commands-only" "no"]); example = "no"; };
      x11Forwarding = mkOption { type = types.bool; example = true; };
    };
  };

  config = {
    boot.loader.grub.enable = true;
    boot.loader.grub.device = "nodev";
    boot.loader.grub.efiSupport = true;
    boot.loader.grub.useOSProber = true;

    boot.tmp = { useTmpfs = true; cleanOnBoot = true; };

    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "${config.hostname}";
    networking.networkmanager.enable = true;

    time.timeZone = "${config.timezone}";

    i18n.defaultLocale = "en_US.UTF-8";
    console = {
      font = "Lat2-Terminus16";
      useXkbConfig = true; # use xkb.options in tty.
    };

    services.xserver = {
      xkb = { layout = "us"; options = "caps:swapescape"; };
      libinput.enable = true;
    };

    services.printing.enable = config.printing.enable;

    security.rtkit.enable = lib.mkIf config.pipewire.enable true;
    services.pipewire = lib.mkIf config.pipewire.enable {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    hardware.bluetooth = lib.mkIf config.bluetooth.enable {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true;
        };
      };
    };

    users.users."${config.username}" = {
      isNormalUser = true;
      extraGroups = [ "networkmanager" "wheel" ];
      initialPassword = "12345";
      # packages = with pkgs; [];
      shell = pkgs.zsh;
    };

    security.sudo.extraRules = lib.mkIf config.sudoWithoutPassword.enable [
      {
        users = ["${config.username}"];
        commands = [
          { command = "ALL"; options = ["NOPASSWD"]; }
        ];
      }
    ];
    security.polkit.enable = true;

    nix = {
      settings = {
        experimental-features = "nix-command flakes";
        auto-optimise-store = true;
      };
      gc = lib.mkIf config.garbageCollection.enable {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
    };

    environment.systemPackages = with pkgs; [
      # BASE-DEVEL
      autoconf
      automake
      binutils
      bison
      coreutils
      debugedit
      fakeroot
      file
      findutils
      flex
      gawk
      gcc
      gettext
      gitFull
      gnugrep
      gnumake
      gnused
      groff
      gzip
      libtool
      m4
      patch
      pkgconf
      texinfo
      which

      clang
      cmake
      curl
      helix
      htop
      home-manager
      lf
      lshw
      neovim
      tailscale
      vim
      wget
    ] ++ lib.optionals config.bluetooth.enable [
      bluetuith
    ] ++ lib.optionals config.pipewire.enable [
      pulsemixer
    ];

    programs.zsh.enable = true;

    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };

    services.openssh = lib.mkIf config.openssh.enable {
      enable = true;
      ports = config.openssh.ports;
      settings = {
        PasswordAuthentication = config.openssh.passwordAuthentication;
        PermitRootLogin = config.openssh.rootLogin;
        X11Forwarding = config.openssh.x11Forwarding;
      };
    };

    services.tailscale = {
      enable = true;
      useRoutingFeatures = "both";
    };

    networking.firewall = lib.mkIf config.firewall.enable {
      enable = true;
      allowedTCPPorts = config.firewall.tcpPorts;
      allowedUDPPorts = config.firewall.udpPorts;
    };

    # DO NOT DELETE
    system.stateVersion = "23.11"; # Did you read the comment?
  };
}

