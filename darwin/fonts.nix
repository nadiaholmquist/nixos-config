{ pkgs, ... }:

{
  fonts.packages = [
    (pkgs.nerdfonts.override.fonts [
      "fira-code"
    ])
  ];
}
