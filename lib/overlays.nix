{ lib ? (import <nixpkgs> {}).lib, ... }:

let
  inherit (builtins) readDir filter attrNames match length;
  inherit (lib) filterAttrs intersectLists;

  overlaysDir = readDir ../overlays;
  allOverlays = map
    (n: import ../overlays/${n})
    (attrNames
      (filterAttrs (n: v:
        (match ".*\\.nix" n) != null && v == "regular"
      ) overlaysDir));

  filterOverlays = tags: filter
    (ov:
      if builtins.isFunction ov then ov
      else length (intersectLists ov.targets tags) != 0)
    allOverlays;

in rec {
  overlaysFor = tags: map (ov: ov.overlay) (filterOverlays tags);
  overlaysModuleFor = tags: {
    nixpkgs.overlays = overlaysFor tags;
  };
}
