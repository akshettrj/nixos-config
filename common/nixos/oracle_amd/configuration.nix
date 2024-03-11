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
    tcpPorts = [22 993];
    udpPorts = [];
  };
  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 4 * 1024;
  }];

  garbageCollection.enable = false;

  openssh = {
    enable = true;
    ports = [22 993];
    passwordAuthentication = false;
    rootLogin = "no";
    x11Forwarding = false;
  };

  fontconfig.enable = false;

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

        hasDisplay = false;
        hyprland.enable = false;
        bemenu.enable = false;
        wezterm.enable = false;
        wayland_packages.enable = false;

        theming = {
          gtk = false;
          qt = false;
        };
      };
    };
  };
}
