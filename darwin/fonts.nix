{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    fira-code
    nerd-fonts.fira-code
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    cascadia-code
  ];
}
