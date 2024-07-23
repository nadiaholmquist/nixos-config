{
  description = "My NixOS configuration.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

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
  };

  outputs = { nixpkgs, darwin, disko, home-manager, ... } @inputs: let
    commonModule = name: {
      nix.settings.experimental-features = "nix-command flakes";
      networking.hostName = name;
      _module.args = { inherit inputs; };

      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      nixpkgs.config.allowUnfree = true;
      home-manager.users.nhp = import ./home;
    };
    nixos = { hostName, systemType, extra ? {} }: nixpkgs.lib.nixosSystem {
      system = systemType;
      modules = [
        ./nixos
        ./hosts/${hostName}
        disko.nixosModules.disko
        home-manager.nixosModules.home-manager
        (commonModule hostName)
      ];
    } // extra;
    macos = { hostName, extra ? {} }: darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./darwin
        ./hosts/${hostName}
        home-manager.darwinModules.home-manager
        (commonModule hostName)
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
    darwinConfigurations = {
      studio = macos {
        hostName = "studio";
      };
    };
  };
}
