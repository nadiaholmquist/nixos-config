{ nixpkgs, home-manager, darwin, disko, ... } @inputs:

let
  #unstablePkgsFor = system: final: prev: rec {
  #  pkgsUnstable = import nixpkgs-unstable {
  #    inherit system;
  #    config.allowUnfree = true;
  #  };
  #};

  commonModuleFor = system: hostName: let
    #unstableOverlay = unstablePkgsFor system;
  in { pkgs, ... }: {
    nix.package = pkgs.lix;
    nix.settings.experimental-features = "nix-command flakes repl-flake";
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
    home-manager.users.nhp = import ../home;
  };
in {
  nixos = { hostName, system, extra ? {} }: let
    commonModule = commonModuleFor system hostName;
  in nixpkgs.lib.nixosSystem {
    system = system;
    specialArgs = { inherit inputs; };
    modules = [
      ../nixos
      ../hosts/${hostName}
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
      ../darwin
      ../hosts/${hostName}
      home-manager.darwinModules.home-manager
      commonModule
      hmModule
    ];
  } // extra;

  home = { hostName, system }: home-manager.lib.homeManagerConfiguration {
    pkgs = import nixpkgs { inherit system; };
    extraSpecialArgs = { inherit inputs; };
    modules = [
      ../hosts/${hostName}
      ../home
    ];
  };
}
