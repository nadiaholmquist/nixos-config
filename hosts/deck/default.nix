{ pkgs, inputs, ... }:

let
  nixGLPkgs = inputs.nixGL.packages.x86_64-linux;
in {
  home.stateVersion = "24.05";
  nixpkgs.config.allowUnfree = true;
  dotfiles.enableGaming = true;
  targets.genericLinux.enable = true;

  home.packages = [
    nixGLPkgs.nixGLIntel
    nixGLPkgs.nixVulkanIntel
    pkgs.gcc
  ];

  home.username = "deck";
}
