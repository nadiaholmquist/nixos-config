{ config, pkgs, lib, ...}:

let
  haveSteam = config.dotfiles.enableGaming && pkgs.hostPlatform.isx86_64;
in {
  options = {
    dotfiles.enableGaming = lib.mkEnableOption "Enable packages for gaming support.";
  };

  config = lib.mkIf haveSteam {
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
