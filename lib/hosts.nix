{
  nixpkgs-nixos-unstable,
  home-manager-nixos-unstable,
  nixpkgs-unstable,
  home-manager-unstable,
  darwin,
  disko,
  ...
} @inputs:

let
  inputsNixOS = {
    inherit (inputs) disko apple-fonts nixos-hardware;
    nixpkgs = nixpkgs-nixos-unstable;
    home-manager = home-manager-nixos-unstable;
  };
  inputsOther = {
    nixpkgs = nixpkgs-unstable;
    home-manager = home-manager-unstable;
  };
  inputsDarwin = inputsOther // {
    inherit (inputs) nix-darwin;
  };
  inputsHomeManager = inputsOther // {
    inherit (inputs) nixGL;
  };

  commonModuleFor = system: hostName: { pkgs, ... }: {
    nix.package = pkgs.lix;
    nix.settings.experimental-features = "nix-command flakes repl-flake";
    nixpkgs.config.allowUnfree = true;

    networking.hostName = hostName;

    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users.nhp = import ../home;
  };
in {
  nixos = { hostName, system }: nixpkgs-nixos-unstable.lib.nixosSystem {
    inherit system;
    specialArgs = { inputs = inputsNixOS; };
    modules = [
      ../nixos
      ../hosts/${hostName}
      disko.nixosModules.disko
      home-manager-nixos-unstable.nixosModules.home-manager
      (commonModuleFor system hostName)
    ];
  };

  macos = { hostName, system ? "aarch64-darwin" }: darwin.lib.darwinSystem {
    inherit system;
    specialArgs = { inputs = inputsDarwin; };
    modules = [
      ../darwin
      ../hosts/${hostName}
      home-manager-unstable.darwinModules.home-manager
      (commonModuleFor system hostName)
    ];
  };

  home = { hostName, system }: home-manager-unstable.lib.homeManagerConfiguration {
    pkgs = import nixpkgs-unstable { inherit system; };
    extraSpecialArgs = { inputs = inputsHomeManager; };
    modules = [
      ../hosts/${hostName}
      ../home
    ];
  };
}
