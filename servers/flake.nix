{
  description = "My NixOS configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
  let
    x86_64-linux-pkgs = import nixpkgs {
      system = "x86_64-linux";
      config = {
        allowUnfree = true;
      };
    };
  in
  {
    nixosConfigurations = {
      oracle_amd_2 = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          pkgs = x86_64-linux-pkgs;
        };
        modules = [
          ./hosts/oracle_amd_2/configuration.nix
        ];
      };
    };

  };
}
