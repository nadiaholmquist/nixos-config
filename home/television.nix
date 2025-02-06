{ pkgs, lib, inputs, ... }:

let
  nix-search-tv = inputs.nix-search-tv.packages."${pkgs.system}".default;
  exe = lib.getExe nix-search-tv;
in {
  home.packages = [
    pkgs.television
    nix-search-tv
  ];

  xdg.configFile."television/nix_channels.toml".text = ''
    [[cable_channel]]
    name = "nixpkgs"
    source_command = "${exe} print"
    preview_command = "${exe} preview {}"
  '';
}
