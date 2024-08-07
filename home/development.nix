{ pkgs, lib, config, ... }:

let
  direnvWrapper = drv: let
    direnvExe = "${config.programs.direnv.package}/bin/direnv";
    exeName = drv.meta.mainProgram;
  in pkgs.writeShellScriptBin "direnv-${exeName}" ''
    exec "${direnvExe}" exec "$PWD" "${drv}/bin/${exeName}" "$@"
  '';
in{
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  # Not in 24.05
  #programs.direnv.silent = true;
  
  # binary wrappers to make IDEs pick up direnvs
  home.packages = [
    (direnvWrapper pkgs.cmake)
    (direnvWrapper pkgs.gnumake)
    (direnvWrapper pkgs.meson)
    (direnvWrapper pkgs.ninja)
  ];
}
