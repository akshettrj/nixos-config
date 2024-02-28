{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ../../../common/nixos/generic/configuration.nix
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager

    ../../../common/nixos/modules/nvidia-intel.nix
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

  home-manager = {
    extraSpecialArgs = { inherit inputs; inherit pkgs; };
    users = {
      "akshettrj" = { ... }: {
        imports = [ ../../../common/home-manager/generic/configuration.nix ];

        username = "akshettrj";
        homedirectory = "/home/akshettrj";

        editors = {
          main = "neovim";
          backup = "helix";
        };

        starship.enable = true;

        hasDisplay = true;

        terminals = {
          main = "wezterm";
          backup = "alacritty";
        };

        hyprland.enable = true;

        bemenu = {
          enable = true;
          fontSize = 15;
          fontName = "Iosevka NF";
        };
      };
    };
  };
}
