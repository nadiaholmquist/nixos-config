{
  pkgs,
  lib,
  inputs,
  ...
}:

let
  inherit (pkgs.stdenv) isDarwin isLinux;

  usedInputs =
    lib.removeAttrs inputs [
      "nixpkgs-nixos"
      "self"
    ]
    // lib.optionalAttrs isLinux { nixpkgs = inputs.nixpkgs-nixos; };
in
{
  nix.settings = {
    # NOT safe on macOS.
    auto-optimise-store = isLinux;
    flake-registry = "";
  };

  nix.gc.automatic = isDarwin;
  nix.optimise.automatic = isDarwin;

  nix.channel.enable = false;

  nix.registry = lib.mapAttrs (_: flake: { inherit flake; }) usedInputs;
  nix.nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") usedInputs;
}
