{
  config,
  inputs,
  pkgs,
  ...
}:
{
  propheci = {
    system = {
      hostname = "oracleamd1";
      time_zone = "Etc/UTC";
      swap_devices = [
        {
          device = "/var/lib/swapfile";
          size = 6 * 1024;
        }
      ];
    };
    user = {
      username = "akshettrj";
      homedir = "/home/akshettrj";
    };
    security = {
      sudo_without_password = true;
      polkit.enable = true;
    };

    hardware = {
      bluetooth.enable = false;
      nvidia.enable = false;
      pulseaudio.enable = false;
    };

    # Various Services
    services = {
      printing.enable = false;
      firewall = {
        enable = true;
        tcp_ports = [ 22 ];
        udp_ports = [ ];
      };
      pipewire.enable = false;
      openssh = {
        server = {
          enable = true;
          ports = [ 22 ];
          password_authentication = false;
          root_login = "no";
          x11_forwarding = false;
        };
      };
      tailscale.enable = true;
      xdg_portal.enable = false;
      telegram_bot_api.enable = false;
    };

    # Nix/NixOS specific
    nix = {
      garbage_collection.enable = false;
      nix_community_cache = true;
      hyprland_cache = false;
      helix_cache = true;
      wezterm_cache = false;
    };

    # Appearance
    theming.enable = false;

    dev = {
      git = {
        enable = true;
        user = {
          name = "Akshett Rai Jindal";
        };
        delta.enable = true;
        default_branch = "main";
      };
      direnv.enable = true;
      cachix.enable = false;
    };

    programs = {
      media = {
        enable = false;
      };
      editors = {
        main = "neovim";
        backup = "helix";
        neovim = {
          enable = true;
          nightly = true;
        };
        helix = {
          enable = true;
          nightly = false;
        };
        zeditor.enable = false;
      };
      terminals.enable = false;
      browsers.enable = false;
      file_explorers = {
        main = "lf";
        backup = "yazi";
        lf.enable = true;
        yazi = {
          enable = true;
          enableFfmpeg = false;
          enableUeberzugpp = false;
        };
      };
      launchers.enable = false;
      screenshot_tools.enable = false;
      notification_daemons.enable = false;
      clipboard_managers.enable = false;
      bars.enable = false;
      screenlocks.enable = false;
    };

    shells = {
      main = "zsh";
      aliases = import ../../common/home-manager/modules/shells/aliases.nix;
      bash.enable = true;
      fish.enable = false;
      nushell.enable = false;
      zsh.enable = true;

      eza.enable = true;
      starship.enable = true;
      zoxide.enable = true;
    };

    desktop_environments.enable = false;
  };
}
