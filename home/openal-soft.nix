{ config, lib, ... }:

{
  xdg.configFile."alsoft.conf".text = lib.generators.toINI {} {
    General = {
      default-hrtf = "IRC_1058_48000";
      frequency = 48000;
      hrtf-paths = "${config.xdg.configHome}/alsoft/hrtf,";
      stereo-mode = "headphones";
    };
  };

  xdg.configFile."alsoft/hrtf/IRC_1058_44100.mhr".source = ./static/IRC_1058_44100.mhr;
  xdg.configFile."alsoft/hrtf/IRC_1058_48000.mhr".source = ./static/IRC_1058_48000.mhr;
}
