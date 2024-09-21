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
  inherit (builtins) filter groupBy listToAttrs;
  inherit (nixpkgs-unstable.lib) pipe;
  inherit (nixpkgs-unstable.lib.lists) flatten;
  inherit (nixpkgs-unstable.lib.attrsets) mapAttrs mapAttrs' mapAttrsToList;

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

  systemFuncs = {
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

    darwin = { hostName, system }: darwin.lib.darwinSystem {
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
  };

  systemAttrs = type: name: def: {
    hostName = def.hostName or name;
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
