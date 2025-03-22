{ lib, ... }:

{
  nix-rosetta-builder = {
    enable = lib.mkDefault false;
    onDemand = true;
  };
}
