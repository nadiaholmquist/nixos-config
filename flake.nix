{
  description = "My NixOS configuration.";

  inputs = {
    nixpkgs-nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Darwin
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs-nixos-unstable";
    };

    home-manager-nixos-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-nixos-unstable";
    };

    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs-nixos-unstable";
    };

    apple-fonts = {
      url = "github:nadiaholmquist/apple-fonts.nix";
      inputs.nixpkgs.follows = "nixpkgs-nixos-unstable";
    };

    nixGL = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { ... } @inputs: let
    inherit (import ./lib/hosts.nix inputs) makeOutputs;
  in makeOutputs {
    nixos = {
      narshe = {};
      # NixOS aarch64 VM on Mac
      nixarm = { system = "aarch64-linux"; };
      wsl = { role = "wsl"; };
    };

    darwin = {
      studio = {};
      nadiabook = {};
    };

    home = {
      deck = {};
    };
  };
}
