{ pkgs, ...}:

{
  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";

  # Select internationalisation properties.
  i18n.defaultLocale = "da_DK.UTF-8";

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "dk";
    xkb.variant = "";
  };

  # Configure console keymap
  console.keyMap = "dk-latin1";
}
