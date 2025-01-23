{ pkgs, lib, config, ... }:

lib.mkIf (config.dotfiles.enableHomeGuiApps && !pkgs.stdenv.isDarwin) {
  # For some reason, setting this through Home Manager fixes the cursor theme being inconsistent in some apps (notablly, JetBrains IDEs and Steam).
  # just setting it in KDE doesn't work.
  # I can even omit the package below and have it make an invalid symlink and it'll still work, very weird...
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.kdePackages.breeze;
    name = "breeze_cursors";
    size = 24;
  };

  gtk.theme.name = "Breeze";

  home.packages = [
    (pkgs.catppuccin-kde.override {
      flavour = ["mocha"];
      accents = ["red"];
    })
  ];

  # KDE likes to overwrite this link with a modified version of the file
  # so tell home-manager to forcibly overwrite it so it doesn't fail to activate when that has happened.
  xdg.configFile."fontconfig/conf.d/10-hm-fonts.conf".force = true;
}
