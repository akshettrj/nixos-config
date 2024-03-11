{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ../../common/nixos/generic/configuration.nix
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager

    ../../common/nixos/modules/nvidia-intel.nix
  ];

  # MODULE SETTINGS - NVIDIA
  nvidia = {
    enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    intelBusId = "PCI:0:2.0";
    nvidiaBusId = "PCI:1:0.0";
  };

  # SYSTEM SETTINGS
  username = "akshettrj";
  sudoWithoutPassword.enable = true;
  timezone = "Asia/Kolkata";
  hostname = "alienrj";
  bluetooth.enable = true;
  pipewire.enable = true;
  printing.enable = true;
  firewall = {
    enable = true;
    tcpPorts = [22];
    udpPorts = [];
  };
  swapDevices = [];

  garbageCollection.enable = true;

  openssh = {
    enable = true;
    ports = [22];
    passwordAuthentication = true;
    rootLogin = "no";
    x11Forwarding = true;
  };

  fontconfig.enable = true;

  home-manager = {
    extraSpecialArgs = { inherit inputs; inherit pkgs; };
    users = {
      "akshettrj" = { ... }: {
        imports = [ ../../common/home-manager/generic/configuration.nix ];

        username = "akshettrj";
        homedirectory = "/home/akshettrj";

        editors = {
          main = "neovim";
          backup = "helix";
        };

        hasDisplay = true;

        terminals = {
          backup = "wezterm";
          main = "alacritty";
        };

        hyprland.enable = true;

        bemenu = {
          enable = true;
          fontSize = 15;
          fontName = "Iosevka NF";
        };

        browsers = {
          main = "brave";
          backups = ["firefox" "chromium"];
        };

        wezterm.enable = true;

        theming = {
          gtk = true;
          qt = true;
          cursorSize = 16;
          font = "Iosevka NF";
          fontSize = 15;
        };
      };
    };
  };
}
