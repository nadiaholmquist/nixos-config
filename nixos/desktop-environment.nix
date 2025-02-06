{ pkgs, ... }:

{
  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    autoNumlock = true;
    theme = "breeze";
  };

  services.desktopManager.plasma6.enable = true;
  programs.kde-pim = {
    enable = true;
    kmail = true;
    kontact = true;
    merkuro = true;
  };

  programs.kdeconnect.enable = true;

  # Add flatpak support
  services.flatpak.enable = true;
  xdg.portal.enable = true;
  fonts.fontDir.enable = true;

  environment.systemPackages = with pkgs; [
    kdePackages.discover

    # Spell checking
    aspell
    aspellDicts.da
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
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
