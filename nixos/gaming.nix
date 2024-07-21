{ config, lib, ...}:

{
  config = lib.mkIf config.dotfiles.enableGaming {
    programs.steam = {
      enable = true;
      extest.enable = true; # Steam Input on Wayland
      gamescopeSession.enable = true;
    };

    programs.gamescope.enable = true;

    # udev rules for Steam Input
    hardware.steam-hardware.enable = true;
  };
}
