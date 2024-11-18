{ pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      # Temporary workaround of unconditionally included cctools which only builds on Darwin
      neovide = prev.neovide.override {
        cctools.libtool = pkgs.runCommandNoCC "empty-drv" {} "mkdir $out";
      };
    })
  ];
}
