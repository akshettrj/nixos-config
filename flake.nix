{
  description = "Akshett's NixOS configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    helix-nightly.url = "github:helix-editor/helix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    {
      nixosConfigurations = {
        alienrj = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            pkgs = import nixpkgs {
              system = "x86_64-linux";
              config = {
                allowUnfree = true;
                allowUnsafe = false;
              };
              overlays = [ ];
            };
          };
          modules = [ ./hosts/alienrj/configuration.nix ];
        };

        oracleamd2 = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            pkgs = import nixpkgs {
              system = "x86_64-linux";
              config = {
                allowUnfree = false;
                allowUnsafe = false;
              };
              overlays = [ ];
            };
          };
          modules = [ ./hosts/oracleamd2/configuration.nix ];
        };
      };
    };
}
