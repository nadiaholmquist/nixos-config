{
  self,
  nixpkgs,
  nixpkgs-nixos,
  home-manager,
  darwin,
  disko,
  ...
} @inputs:

let
  inherit (builtins) filter groupBy listToAttrs attrValues;
  inherit (nixpkgs) lib;
  inherit (lib) assertMsg;
  inherit (lib.lists) flatten;
  inherit (lib.attrsets) mapAttrs mapAttrs' mapAttrsToList;

  inherit (import ./overlays.nix { inherit lib; }) overlaysModuleFor;
  roleModules = import ../nixos/role-modules.nix { inputs = inputsNixOS; };

  inputsNixOS = inputs // {
    nixpkgs = nixpkgs-nixos;
  };

  commonModuleFor = system: hostName: { ... }: {
    nix.settings.experimental-features = "nix-command flakes pipe-operators";
    nixpkgs.config.allowUnfree = true;

    networking.hostName = hostName;

    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users.nhp = import ../home;
  };

  homePkgs.x86_64-linux = import nixpkgs { system = "x86_64-linux"; };

  systemFuncs = {
    nixos = { hostName, system, role, ... }: nixpkgs-nixos.lib.nixosSystem rec {
      inherit system;
      specialArgs = { inputs = inputsNixOS; };
      modules = [
        disko.nixosModules.disko
        home-manager.nixosModules.home-manager
        (commonModuleFor system hostName)
        { home-manager.extraSpecialArgs = specialArgs; }
        (overlaysModuleFor ["nixos" system hostName])
        ../hosts/${hostName}
      ]
      ++ roleModules.common
      ++ roleModules."${role}";
    };

    darwin = { hostName, system, ... }: darwin.lib.darwinSystem rec {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        ../darwin
        ../hosts/${hostName}
        home-manager.darwinModules.home-manager
        { home-manager.extraSpecialArgs = specialArgs; }
        (commonModuleFor system hostName)
        (overlaysModuleFor ["darwin" system hostName])
      ];
    };

    home = { hostName, system, ... }: home-manager.lib.homeManagerConfiguration {
      pkgs = homePkgs."${system}";
      extraSpecialArgs = { inherit inputs; };
      modules = [
        ../hosts/${hostName}
        ../home
        (overlaysModuleFor ["home" system hostName])
      ];
    };
  };

  systemAttrs = type: name: def: {
    inherit type;
    hostName = def.hostName or name;
    role = def.role or "desktop";
    system = def.system or (
      if type == "darwin" then "aarch64-darwin" else "x86_64-linux"
    );
  };

  applySystemAttrs =
    mapAttrs (type:
      mapAttrs (systemAttrs type)
    );

  makeSystems =
    mapAttrs' (type: systems: {
      name = type + "Configurations";
      value = mapAttrs (_: systemFuncs."${type}") systems;
    });

  makeChecks = defs: defs
    |> mapAttrsToList (_: attrValues)
    |> flatten
    |> filter (def: def.type != "nixos")
    |> groupBy (def: def.system)
    |> mapAttrs (_: defs: defs
      |> map (def:
        let
          inherit (def) type hostName;
          activation =
            if type == "darwin" then self.darwinConfigurations."${hostName}".system
            else if type == "home" then self.homeConfigurations."${hostName}".activationPackage
            else assertMsg false "Unknown system";
        in
          {
            name = hostName;
            value = activation;
          })
      |> listToAttrs);


in
  defs:
    let
      applied = applySystemAttrs defs;
    in
      (makeSystems applied)
      // { checks = makeChecks applied; }
