{ config, lib, pkgs, ... }:

{
  imports = [];

  options = let
    inherit (lib) mkOption mkEnableOption types;
  in {
    username = mkOption {
      type = types.str;
      example = "akshettrj";
      description = ''
        The username of the main user of the system
      '';
    };

    sudoWithoutPassword.enable = mkEnableOption("Allow user to run sudo commands without password");

    timezone = mkOption {
      type = types.str;
      example = "Asia/Kolkata";
      description = ''
        The timezone of your system
      '';
    };

    hostname = mkOption {
      type = types.str;
      description = ''
        The networking hostname of the system
      '';
    };

    bluetooth.enable = mkEnableOption("Enable bluetooth");

    enablePrinting = mkOption {
      type = types.bool;
      example = false;
      description = ''
        Whether to enable CUPS printing in the system
      '';
    };

    enableFirewall = mkOption {
      type = types.bool;
      example = true;
      description = ''
        Whether to enable the network firewall in the system
      '';
    };

    firewallTCPPorts = mkOption {
      type = types.listOf(types.port);
      example = [22];
      description = ''
        List of TCP ports to be opened in the firewall
      '';
    };

    firewallUDPPorts = mkOption {
      type = types.listOf(types.port);
      example = [];
      description = ''
        List of UDP ports to be opened in the firewall
      '';
    };
  };

  config = {
    boot.loader.grub.enable = true;
    boot.loader.grub.device = "nodev";
    boot.loader.grub.efiSupport = true;
    boot.loader.grub.useOSProber = true;

    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "${config.hostname}";
    networking.networkmanager.enable = true;

    time.timeZone = "${config.timezone}";

    i18n.defaultLocale = "en_US.UTF-8";
    console = {
      font = "Lat2-Terminus16";
      useXkbConfig = true; # use xkb.options in tty.
    };

    services.xserver.xkb.layout = "us";
    services.xserver.xkb.options = "caps:swapescape";

    services.printing.enable = config.enablePrinting;

    security.rtkit.enable = true;
    services.pipewire = {
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

    services.xserver.libinput.enable = true;

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
          {
            command = "ALL";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];
    security.polkit.enable = true;

    nix.settings.experimental-features = "nix-command flakes";

    environment.systemPackages = with pkgs; [
      # BASE-DEVEL
      autoconf
      automake
      binutils
      bison
      debugedit
      fakeroot
      file
      findutils
      flex
      gawk
      gcc
      gettext
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

      bluetuith
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
    ];

    programs.zsh.enable = true;

    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };

    services.openssh.enable = true;

    services.tailscale = {
      enable = true;
      useRoutingFeatures = "both";
    };

    networking.firewall.enable = config.enableFirewall;
    networking.firewall.allowedTCPPorts = config.firewallTCPPorts;
    networking.firewall.allowedUDPPorts = config.firewallUDPPorts;

    # DO NOT DELETE
    system.stateVersion = "23.11"; # Did you read the comment?
  };
}

