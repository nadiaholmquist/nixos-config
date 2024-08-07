{ pkgs, lib, ... }:

let
  direnvWrapper = prog: pkgs.writeShellScriptBin "direnv-${prog}" ''
    exec direnv exec "$PWD" "${prog}" "$@"
  '';
in{
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  # Not in 24.05
  #programs.direnv.silent = true;
  
  # binary wrappers to make IDEs pick up direnvs
  home.packages = [
    (direnvWrapper "cmake")
    (direnvWrapper "make")
    (direnvWrapper "meson")
    (direnvWrapper "ninja")
  ];
}
