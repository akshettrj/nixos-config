{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ../generic/configuration.nix
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager

    ../modules/nvidia-intel.nix
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
  enablePrinting = true;
  enableFirewall = true;
  firewallTCPPorts = [22];
  firewallUDPPorts = [];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "akshettrj" = { ... }: {
        imports = [ ../../home-manager/generic/configuration.nix ];

        username = "akshettrj";
        homedirectory = "/home/akshettrj";

        defaultEditor = "neovim";
        backupEditor = "helix";

        mainTerminal = "wezterm";
        backupTerminal = "alacritty";

        starship.enable = true;

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
