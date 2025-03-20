{
  description = "My NixOS configuration.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-nixos.url = "github:NixOS/nixpkgs/nixos-unstable";

    treefmt-nix.url = "github:numtide/treefmt-nix";

    # Darwin
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs-nixos";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs-nixos";
    };

    nixGL = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    import ./lib/hosts.nix inputs {
      nixos = {
        narshe = { };
        # NixOS aarch64 VM on Mac
        nixarm = {
          system = "aarch64-linux";
        };
        pbp = {
          system = "aarch64-linux";
        };
        wsl = {
          role = "wsl";
        };
        rock5 = {
          system = "aarch64-linux";
        };
      };

      darwin = {
        studio = { };
        nadiabook = { };
      };

      home = {
        deck = { };
      };
    };
}
