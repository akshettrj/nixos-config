{
    description = "Akshett's NixOS configuration flake";

    nixConfig = {
        extra-substituters = [
            "https://propheci.cachix.org"
            "https://watgbridge.cachix.org"
            "https://nix-community.cachix.org"
            "https://hyprland.cachix.org"
            "https://helix.cachix.org"
        ];
        extra-trusted-public-keys = [
            "propheci.cachix.org-1:CwV87KMySX+rhW88NhTx2hRzdNltV497nhXvWswFGDc="
            "watgbridge.cachix.org-1:KSfgmbSBvXQTpUnoCj21vST7zgwpy3SbNfk0/nesR1Y="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
            "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
        ];
    };

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        # Hyprland related
        hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
        hyprpaper = {
            url = "github:hyprwm/hyprpaper";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        hyprlock = {
            url = "github:hyprwm/hyprlock";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        waybar = {
            url = "github:Alexays/Waybar";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        # Text editors
        neovim.url = "github:nix-community/neovim-nightly-overlay";
        helix.url = "github:helix-editor/helix";

        # Utilities
        nix-index-database = {
            url = "github:nix-community/nix-index-database";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nur.url = "github:nix-community/NUR";

        # Misc
        wallpapers = {
            url = "github:Propheci/wallpapers";
            flake = false;
        };

        propheci_secrets = {
            url = "git+ssh://git@github.com/akshettrj/nixos_flake_secrets.git";
            flake = false;
        };
    };

    outputs = { self, nixpkgs, ... }@inputs:
    let

        common_overlays = [];

    in {
        nixosConfigurations = {
            alienrj = nixpkgs.lib.nixosSystem {
                specialArgs = {
                    inherit inputs;
                    pkgs = import nixpkgs {
                        system = "x86_64-linux";
                        config = { allowUnfree = true; allowUnsafe = false; };
                        overlays = common_overlays;
                    };
                };
                modules = [ ./hosts/alienrj/configuration.nix ];
            };

            oracleamd1 = nixpkgs.lib.nixosSystem {
                specialArgs = {
                    inherit inputs;
                    pkgs = import nixpkgs {
                        system = "x86_64-linux";
                        config = { allowUnfree = false; allowUnsafe = false; };
                        overlays = common_overlays;
                    };
                };
                modules = [ ./hosts/oracleamd1/configuration.nix ];
            };

            oracleamd2 = nixpkgs.lib.nixosSystem {
                specialArgs = {
                    inherit inputs;
                    pkgs = import nixpkgs {
                        system = "x86_64-linux";
                        config = { allowUnfree = false; allowUnsafe = false; };
                        overlays = common_overlays;
                    };
                };
                modules = [ ./hosts/oracleamd2/configuration.nix ];
            };

            raspi = nixpkgs.lib.nixosSystem {
                specialArgs = {
                    inherit inputs;
                    pkgs = import nixpkgs {
                        system = "aarch64-linux";
                        config = { allowUnfree = false; allowUnsafe = false; };
                        overlays = common_overlays;
                    };
                };
                modules = [ ./hosts/raspi/configuration.nix ];
            };
        };

        templates = {
            golang = {
                path = ./templates/golang;
                description = "Flake for Golang devShell and packaging";
            };
            python_poetry = {
                path = ./templates/python_poetry;
                description = "Flake for Python poetry devShell and packaging";
            };
            rust_workspace = {
                path = ./templates/rust_workspace;
                description = "Flake for Cargo workspace libraries";
            };
            rust = {
                path = ./templates/rust;
                description = "Flake for Cargo non-workspace binaries";
            };
            rust_lib = {
                path = ./templates/rust_lib;
                description = "Flake for Cargo non-workspace libraries";
            };
        };
    };
}
