{
  pkgs,
  lib,
  inputs,
  ...
}:

let
  inherit (pkgs.stdenv) isDarwin isLinux;
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

  nix.registry = lib.mapAttrs (_: flake: { inherit flake; }) inputs;
  nix.nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") inputs;
}
