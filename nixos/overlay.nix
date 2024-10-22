{ ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      # Work around node-env build failure
      utillinux = null;
    })
  ];
}
