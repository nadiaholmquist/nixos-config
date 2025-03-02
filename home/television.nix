{
  pkgs,
  lib,
  ...
}:

let
  exe = lib.getExe pkgs.nix-search-tv;
in
{
  home.packages = [
    pkgs.television
    pkgs.nix-search-tv
  ];

  xdg.configFile."television/nix_channels.toml".text = ''
    [[cable_channel]]
    name = "nixpkgs"
    source_command = "${exe} print"
    preview_command = "${exe} preview {}"
  '';
}
