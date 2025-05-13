{
  pkgs,
  lib,
  inputs,
  ...
}:

let
  inherit (lib) mkIf;
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux isx86_64;
in
{
  nix.settings = {
    # NOT safe on macOS.
    auto-optimise-store = isLinux;
    flake-registry = "";
    system-features = mkIf (isLinux && isx86_64) [
      # x86_64-v3 is Haswell and newer, roughly
      "gccarch-x86-64-v3"
    ];
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
