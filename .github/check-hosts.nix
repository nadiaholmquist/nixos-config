let
  inherit (builtins) getFlake toString mapAttrs tryEval attrValues all trace seq deepSeq concatStringsSep;

  flake = getFlake (toString ../.);

  darwinConfigs = mapAttrs
    (name: config:
      trace "Checking Darwin configuration '${name}'"
      config.config.system.build.toplevel
    )
    flake.darwinConfigurations;

  homeConfigs = mapAttrs
    (name: config:
      trace "Checking Home Manager configuration '${name}'"
      config.activationPackage
    )
    flake.homeConfigurations;
in
  concatStringsSep "\n" ((attrValues darwinConfigs) ++ (attrValues homeConfigs))
