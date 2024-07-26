{ pkgs, ... }:

{
  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.sddm.autoNumlock = true;
  services.displayManager.sddm.theme = "breeze";
  services.desktopManager.plasma6.enable = true;

  # Add flatpak support
  services.flatpak.enable = true;
  xdg.portal.enable = true;
  fonts.fontDir.enable = true;

  # Add Discover for managing flatpaks
  environment.systemPackages = with pkgs; [
    kdePackages.kmail
    kdePackages.kmail-account-wizard
    kdePackages.discover
    kde-gruvbox
    (catppuccin-kde.override {
      flavour = ["mocha"];
      accents = ["red"];
    })
  ];

  # Electron applications should use Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = 1;

  # AppImage support
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  # This is only enabled by default on systems with services.xserver.enabled set to true, and we don't have that
  # I don't know if it actually matters though tbh
  gtk.iconCache.enable = true;
}
