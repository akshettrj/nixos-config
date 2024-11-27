{
  description = "A basic flake for Golang development";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nix-filter.url = "github:numtide/nix-filter";
    gomod2nix = {
      url = "github:nix-community/gomod2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    nix-filter,
    gomod2nix,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [gomod2nix.overlays.default];
        };
      in {
        devShell = pkgs.mkShell {
          name = builtins.throw "please enter dev-shell name in flake.nix";
          buildInputs = with pkgs; [
            go
            gopls
            gomod2nix.packages."${system}".default
          ];
        };

        packages = rec {
          name = pkgs.callPackage ./nix/pkgs/name.nix {inherit nix-filter;};
          default = name;
        };
      }
    );
}
