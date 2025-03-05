{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkIf mkEnableOption;
  enableGaming = config.dotfiles.enableGaming;
  haveSteam = lib.meta.availableOn pkgs.hostPlatform pkgs.steam;
in
{
  options = {
    dotfiles.enableGaming = mkEnableOption "Enable packages for gaming support.";
  };

  config = mkIf enableGaming {
    programs.gamemode.enable = true;

    programs.gamescope.enable = true;

    environment.systemPackages = [
      pkgs.vulkan-hdr-layer-kwin6
    ];

    # udev rules for Steam Input
    hardware.steam-hardware.enable = true;

    programs.steam = mkIf haveSteam {
      enable = true;
      extest.enable = true; # Steam Input on Wayland
    };
  };
}
