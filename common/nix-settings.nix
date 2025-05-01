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

  nix.nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") inputs;
  nix.registry = lib.mapAttrs (_: flake: { inherit flake; }) inputs // {
    templates = {
      from = {
        id = "templates";
        type = "indirect";
      };
      to = {
        type = "github";
        owner = "NixOS";
        repo = "templates";
      };
    };
  };
}
