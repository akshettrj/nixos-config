{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ../../../common/nixos/generic/configuration.nix
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  # SYSTEM SETTINGS
  username = "akshettrj";
  sudoWithoutPassword.enable = true;
  timezone = "UTC";
  hostname = "oracle_amd_2";
  bluetooth.enable = false;
  enablePrinting = false;
  enableFirewall = true;
  firewallTCPPorts = [22];
  firewallUDPPorts = [];
  swaps = [{
    device = "/var/lib/swapfile";
    size = 4 * 1024;
  }];

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

        terminals.enable = false;
        hyprland.enable = false;
        bemenu.enable = false;
      };
    };
  };
}
