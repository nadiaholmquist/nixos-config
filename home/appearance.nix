{ pkgs, lib, ... }:

lib.mkIf pkgs.stdenv.isLinux {
  # For some reason, setting this through Home Manager fixes the cursor theme being inconsistent in some apps (notablly, JetBrains IDEs and Steam).
  # just setting it in KDE doesn't work.
  # I can even omit the package below and have it make an invalid symlink and it'll still work, very weird...
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.kdePackages.breeze;
    name = "breeze_cursors";
  };

  gtk.theme.name = "Breeze";

  home.packages = [
    (pkgs.catppuccin-kde.override {
      flavour = ["mocha"];
      accents = ["red"];
    })
  ];
}
