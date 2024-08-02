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
  };

  outputs = { nixpkgs, darwin, disko, home-manager, ... } @inputs: let
    #unstablePkgsFor = system: final: prev: rec {
    #  pkgsUnstable = import nixpkgs-unstable {
    #    inherit system;
    #    config.allowUnfree = true;
    #  };
    #};

    commonModuleFor = system: hostName: let
      #unstableOverlay = unstablePkgsFor system;
    in {
      nix.settings.experimental-features = "nix-command flakes";
      networking.hostName = hostName;

      nixpkgs.config.allowUnfree = true;
      #nixpkgs.overlays = [ unstableOverlay ];
    };

    hmModule = {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.sharedModules = [
        { _module.args = { inherit inputs; }; }
      ];
      home-manager.users.nhp = import ./home;
    };

    nixos = { hostName, system, extra ? {} }: let
      commonModule = commonModuleFor system hostName;
    in nixpkgs.lib.nixosSystem {
      system = system;
      specialArgs = { inherit inputs; };
      modules = [
        ./nixos
        ./hosts/${hostName}
        disko.nixosModules.disko
        home-manager.nixosModules.home-manager
        commonModule
        hmModule
      ];
    } // extra;

    macos = { hostName, extra ? {} }: let
      system = "aarch64-darwin";
      commonModule = commonModuleFor system hostName;
    in darwin.lib.darwinSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        ./darwin
        ./hosts/${hostName}
        home-manager.darwinModules.home-manager
        commonModule
        hmModule
      ];
    } // extra;
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
    };
  };
}
