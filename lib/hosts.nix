{
  nixpkgs-nixos-unstable,
  home-manager-nixos-unstable,
  nixpkgs-unstable,
  home-manager-unstable,
  darwin,
  nixos-wsl,
  disko,
  ...
} @inputs:

let
  inherit (builtins) filter groupBy listToAttrs;
  inherit (nixpkgs-unstable) lib;
  inherit (lib) pipe;
  inherit (lib.lists) flatten;
  inherit (lib.attrsets) mapAttrs mapAttrs' mapAttrsToList;
  inherit (import ./overlays.nix { inherit lib; }) overlaysModuleFor;

  inputsNixOS = {
    inherit (inputs) disko apple-fonts nixos-hardware;
    nixpkgs = nixpkgs-nixos-unstable;
    home-manager = home-manager-nixos-unstable;
    nixos-wsl = nixos-wsl;
  };
  inputsOther = {
    nixpkgs = nixpkgs-unstable;
    home-manager = home-manager-unstable;
  };
  inputsDarwin = inputsOther // {
    inherit (inputs) nix-darwin nh;
  };
  inputsHomeManager = inputsOther // {
    inherit (inputs) nixGL;
  };

  commonModuleFor = system: hostName: { ... }: {
    nix.settings.experimental-features = "nix-command flakes";
    nixpkgs.config.allowUnfree = true;

    networking.hostName = hostName;

    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users.nhp = import ../home;
  };

  systemFuncs = {
    nixos = { hostName, system, role }: let
      roleModules = import ../nixos/role-modules.nix { inputs = inputsNixOS; };
    in nixpkgs-nixos-unstable.lib.nixosSystem {
      inherit system;
      specialArgs = { inputs = inputsNixOS; };
      modules = [
        disko.nixosModules.disko
        home-manager-nixos-unstable.nixosModules.home-manager
        (commonModuleFor system hostName)
        (overlaysModuleFor ["nixos" system hostName])
        ../hosts/${hostName}
      ]
      ++ roleModules.common
      ++ roleModules."${role}";
    };

    darwin = { hostName, system, ... }: darwin.lib.darwinSystem {
      inherit system;
      specialArgs = { inputs = inputsDarwin; };
      modules = [
        ../darwin
        ../hosts/${hostName}
        home-manager-unstable.darwinModules.home-manager
        (commonModuleFor system hostName)
        (overlaysModuleFor ["darwin" system hostName])
      ];
    };

    home = { hostName, system, ... }: home-manager-unstable.lib.homeManagerConfiguration {
      pkgs = import nixpkgs-unstable { inherit system; };
      extraSpecialArgs = { inputs = inputsHomeManager; };
      modules = [
        ../hosts/${hostName}
        ../home
        (overlaysModuleFor ["home" system hostName])
      ];
    };
  };

  systemAttrs = type: name: def: {
    hostName = def.hostName or name;
    role = def.role or "desktop";
    system = def.system or (
      if type == "darwin" then "aarch64-darwin" else "x86_64-linux"
    );
  };

  makeSystem = type: name: def: systemFuncs."${type}" (systemAttrs type name def);

  makeSystems = defs: mapAttrs' (type: value: {
      name = type + "Configurations";
      value = mapAttrs (makeSystem type) value;
    }) defs;

  makeChecks = defs: pipe defs [
    (mapAttrsToList (type: systems:
      mapAttrs (name: value:
        (systemAttrs type name value) // { inherit type; }
      ) systems))
    (map (list:
      mapAttrsToList (name: value: value // { inherit name; }) list
    ))
    flatten
    (filter (config: config.type != "nixos" && config.type != "home"))
    (groupBy (config: config.system))
    (mapAttrs (system: defs:
      listToAttrs (map (def: {
        name = def.name;
        value = if def.type == "home" then
          inputs.self."${def.type}Configurations"."${def.name}".activationPackage
        else
          inputs.self."${def.type}Configurations"."${def.name}".config.system.build.toplevel;
      }) defs)
    ))
  ];

in {
  makeOutputs = defs: let
    systems = makeSystems defs;
    checks = makeChecks defs;
  in systems // { inherit checks; };
}
