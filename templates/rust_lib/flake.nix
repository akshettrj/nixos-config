{
  description = "A very basic flake for rust non-workspace library projects";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    fenix.url = "github:nix-community/fenix";
    nix-filter.url = "github:numtide/nix-filter";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      fenix,
      nix-filter,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };

        rustToolchain = fenix.packages."${system}".stable.toolchain;
      in
      with pkgs;
      {
        devShells.default = mkShell {
          name = "<name>";

          buildInputs = [
            clang
            rustToolchain
            protobuf
            taplo
          ];
        };
      }
    );
}
