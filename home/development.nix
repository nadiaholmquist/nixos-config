{
  pkgs,
  lib,
  config,
  ...
}:

let
  direnvWrapper =
    drv:
    let
      direnvExe = "${config.programs.direnv.package}/bin/direnv";
      exeName = drv.meta.mainProgram;
    in
    pkgs.writeShellScriptBin "direnv-${exeName}" ''
      exec "${direnvExe}" exec "$PWD" "${drv}/bin/${exeName}" "$@"
    '';

  # binary wrappers to make IDEs pick up direnvs
  wrappers = map direnvWrapper (
    with pkgs;
    [
      cmake
      gnumake
      meson
      ninja
    ]
  );
in
{
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  home.packages = wrappers ++ [
    pkgs.rustup
  ];
}
