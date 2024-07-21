{ config, lib, pkgs, ... }:
  
{
  config = lib.mkIf config.dotfiles.enableFanControl {
    programs.coolercontrol.enable = true;
    environment.systemPackages = with pkgs; [
      lm_sensors
    ];
  };
}
