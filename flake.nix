{
  description = "My NixOS configuration.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
  };

  outputs = { nixpkgs, disko, home-manager, ... } @inputs: let
    nixos = { hostName, systemType, extra ? {} }: nixpkgs.lib.nixosSystem {
      system = systemType;
      modules = [
        ./nixos
        ./hosts/${hostName}
        {
          networking.hostName = hostName;
          _module.args = {
            inherit inputs;
            system = systemType;
          };
        }
        disko.nixosModules.disko
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          nixpkgs.config.allowUnfree = true;

          home-manager.users.nhp = {
            imports = [ ./home ];
          };
        }
      ];
    } // extra;
  in {
    nixosConfigurations = {
      narshe = nixos {
        hostName = "narshe";
        systemType = "x86_64-linux";
      };
      testvm = nixos {
        hostName = "testvm";
        systemType = "x86_64-linux";
      };
      nixarm = nixos { # NixOS aarch64 VM on Mac
        hostName = "nixarm";
        systemType = "aarch64-linux";
      };
    };
  };
}
