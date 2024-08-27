{
  description = "My NixOS configuration.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    #nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    apple-fonts = {
      url = "github:nadiaholmquist/apple-fonts.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixGL = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... } @inputs: let
    inherit (import ./lib/hosts.nix inputs) nixos macos home;
  in {
    nixosConfigurations = {
      narshe = nixos {
        hostName = "narshe";
        system = "x86_64-linux";
      };
      nixarm = nixos { # NixOS aarch64 VM on Mac
        hostName = "nixarm";
        system = "aarch64-linux";
      };
    };
    darwinConfigurations = {
      studio = macos {
        hostName = "studio";
      };
      nadiabook = macos {
        hostName = "nadiabook";
      };
    };

    homeConfigurations = {
      deck = home {
        hostName = "deck";
        system = "x86_64-linux";
      };
    };
  };
}
