{ lib ? (import <nixpkgs> {}).lib, ... }:

let
  inherit (builtins) readDir filter attrNames match length isFunction;
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
      if isFunction ov then true
      else length (intersectLists ov.targets tags) != 0)
    allOverlays;

in rec {
  overlaysFor = tags: map
    (ov:
      if isFunction ov then ov
      else ov.overlay)
    (filterOverlays tags);
  overlaysModuleFor = tags: {
    nixpkgs.overlays = overlaysFor tags;
  };
}
