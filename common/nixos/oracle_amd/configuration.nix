{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ../generic/configuration.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  sudoWithoutPassword.enable = true;
  timezone = "UTC";
  username = "akshettrj";
  bluetooth.enable = false;
  pipewire.enable = false;
  printing.enable = false;
  firewall = {
    enable = true;
    tcpPorts = [22];
    udpPorts = [];
  };
  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 4 * 1024;
  }];

  garbageCollection.enable = false;

  home-manager = {
    extraSpecialArgs = { inherit inputs; inherit pkgs; };
    users = {
      "akshettrj" = { ... }: {
        imports = [ ../../home-manager/generic/configuration.nix ];

        username = "akshettrj";
        homedirectory = "/home/akshettrj";

        editors = {
          main = "neovim";
          backup = "helix";
        };

        starship.enable = true;

        terminals.enable = false;
        hyprland.enable = false;
        bemenu.enable = false;
      };
    };
  };
}
