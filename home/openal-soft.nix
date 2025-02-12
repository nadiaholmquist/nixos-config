{ pkgs, lib, ... }:

let
  hrtfs = pkgs.runCommandNoCC "alsoft-hrtfs-dir" { } ''
    cp -r "${./static/hrtfs}" $out
  '';

in
{
  xdg.configFile."alsoft.conf".text = lib.generators.toINI { } {
    General = {
      default-hrtf = "IRC_1058_48000";
      frequency = 48000;
      hrtf-paths = "${hrtfs},";
      stereo-mode = "headphones";
    };
  };
}
