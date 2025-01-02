{
  targets = ["nixos"];
  overlay = final: prev: {
    nanoboyadvance = prev.nanoboyadvance.overrideAttrs {
      patches = [
        # Fix build with gcc 14
        (final.fetchpatch {
          url = "https://github.com/nba-emu/NanoBoyAdvance/commit/f5551cc1aa6a12b3d65dd56d186c73a67f3d9dd6.patch";
          hash = "sha256-TCyN0qz7o7BDhVZtaTsWCZAcKThi5oVqUM0NGmj44FI=";
        })
      ];
    };
  };
}
