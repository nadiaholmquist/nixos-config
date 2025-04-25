{
  self,
  nixpkgs,
  nixpkgs-nixos,
  home-manager,
  darwin,
  disko,
  treefmt-nix,
  nix-rosetta-builder,
  ...
}@inputs:

let
  inherit (nixpkgs) lib;
  inherit (lib) genAttrs;
  inherit (lib.attrsets) mapAttrs mapAttrs' removeAttrs;

  inherit (import ./overlays.nix { inherit lib; }) overlaysModuleFor;
  roleModules = import ../nixos/role-modules.nix { inputs = inputsNixOS; };

  systems = [
    "aarch64-darwin"
    "aarch64-linux"
    "x86_64-darwin"
    "x86_64-linux"
  ];

  inputsCommon = removeAttrs inputs [ "nixpkgs-nixos" ];

  inputsNixOS = inputsCommon // {
    nixpkgs = nixpkgs-nixos;
  };

  commonModuleFor =
    system: hostName:
    { ... }:
    {
      nix.settings.experimental-features = "nix-command flakes pipe-operators";
      nixpkgs.config.allowUnfree = true;

      networking.hostName = hostName;

      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.nhp = import ../home;
    };

  homePkgs.x86_64-linux = import nixpkgs { system = "x86_64-linux"; };

  systemFuncs = {
    nixos =
      {
        hostName,
        system,
        role,
        ...
      }:
      nixpkgs-nixos.lib.nixosSystem rec {
        inherit system;
        specialArgs = {
          inputs = inputsNixOS;
        };
        modules =
          [
            disko.nixosModules.disko
            home-manager.nixosModules.home-manager
            (commonModuleFor system hostName)
            { home-manager.extraSpecialArgs = specialArgs; }
            (overlaysModuleFor [
              "nixos"
              system
              hostName
            ])
            ../hosts/${hostName}
          ]
          ++ roleModules.common
          ++ roleModules."${role}";
      };

    darwin =
      { hostName, system, ... }:
      darwin.lib.darwinSystem rec {
        inherit system;
        specialArgs = {
          inputs = inputsCommon;
        };
        modules = [
          ../darwin
          ../hosts/${hostName}
          home-manager.darwinModules.home-manager
          { home-manager.extraSpecialArgs = specialArgs; }
          nix-rosetta-builder.darwinModules.default
          (commonModuleFor system hostName)
          (overlaysModuleFor [
            "darwin"
            system
            hostName
          ])
        ];
      };

    home =
      { hostName, system, ... }:
      home-manager.lib.homeManagerConfiguration {
        pkgs = homePkgs."${system}";
        extraSpecialArgs = {
          inputs = inputsCommon;
        };
        modules = [
          ../hosts/${hostName}
          ../home
          (overlaysModuleFor [
            "home"
            system
            hostName
          ])
        ];
      };
  };

  systemAttrs = type: name: def: {
    inherit type;
    hostName = def.hostName or name;
    role = def.role or "desktop";
    system = def.system or (if type == "darwin" then "aarch64-darwin" else "x86_64-linux");
  };

  applySystemAttrs = mapAttrs (type: mapAttrs (systemAttrs type));

  makeSystems = mapAttrs' (
    type: systems: {
      name = type + "Configurations";
      value = mapAttrs (_: systemFuncs."${type}") systems;
    }
  );

  eachSystem = genAttrs systems;
  treefmtEval = eachSystem (
    system: treefmt-nix.lib.evalModule nixpkgs.legacyPackages.${system} ../treefmt.nix
  );
  formatter = eachSystem (system: treefmtEval.${system}.config.build.wrapper);

  makeOutputs =
    defs:
    let
      applied = applySystemAttrs defs;
      checks = eachSystem (system: {
        formatting = treefmtEval.${system}.config.build.check self;
      });
    in
    (makeSystems applied)
    // {
      inherit checks formatter;
    };

in
makeOutputs
