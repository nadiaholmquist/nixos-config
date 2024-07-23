{ config, ... }:

let
  xdgConfig = config.xdg.configHome;
in{
  xdg.configFile."alsoft.conf".text = ''
    [General]
    default-hrtf=IRC_1058_48000
    hrtf-paths="${xdgConfig}/alsoft/hrtf,"
  '';

  xdg.configFile."alsoft/hrtf/IRC_1058_44100.mhr".source = ./static/IRC_1058_44100.mhr;
  xdg.configFile."alsoft/hrtf/IRC_1058_48000.mhr".source = ./static/IRC_1058_48000.mhr;
}
