{ config, pkgs, lib, ...}:

let
  haveSteam = config.dotfiles.enableGaming && pkgs.hostPlatform.isx86_64;
in {
  options = {
    dotfiles.enableGaming = lib.mkEnableOption "Enable packages for gaming support.";
  };

  config = lib.mkIf haveSteam {
    environment.systemPackages = [
      (pkgs.callPackage ../pkgs/vk-hdr-layer.nix {})
    ];

    programs.steam = {
      enable = true;
      package = pkgs.steam.override {
        extraPkgs = pkgs: with pkgs; [
          xorg.libXcursor
          xorg.libXi
          xorg.libXinerama
          xorg.libXScrnSaver
          libpng
          libpulseaudio
          libvorbis
          stdenv.cc.cc.lib
          libkrb5
          keyutils
        ];
      };
      extest.enable = true; # Steam Input on Wayland
      gamescopeSession.enable = true;
      extraCompatPackages = [
        pkgs.proton-ge-bin
      ];
      extraPackages = with pkgs; [
        gamescope
      ];
    };

    programs.gamescope.enable = true;

    # udev rules for Steam Input
    hardware.steam-hardware.enable = true;
  };
}
