{ config, lib, pkgs, ... }:

# Graphical apps
# I only use Nix to manage graphical apps on Linux.
# The way Nix wants to symlink apps into Applications on macOS doesn't work in a way that I find particularly nice to use, so I just manage apps manually there.

let
  inherit (lib) optionals mkIf;
  inherit (pkgs.hostPlatform) isx86_64 isLinux isDarwin;

  x86_64Packages = optionals isx86_64 (with pkgs; [
    discord
    bitwarden-desktop
    cider # Apple Music

    jetbrains-toolbox
    jetbrains.clion

    furmark
    zenmonitor
  ]);

  commonPackages = with pkgs; [
    # Graphical apps
    mpv
    neovim-qt
    audacity

    # Dev programs
    neovide
  ];

  gamingPackages = optionals config.dotfiles.enableGaming (with pkgs; [
    prismlauncher # Minecraft

    # Emulators
    cemu
    dolphin-emu-beta
    duckstation
    ares
    nanoboyadvance
    mgba
    melonDS
    (retroarch.override {
      cores = with libretro; [
        mesen bsnes snes9x genesis-plus-gx mupen64plus
      ];
    })
    pcsx2
    ryujinx
  ]);
in mkIf isLinux {
  home.packages = commonPackages
    ++ x86_64Packages
    ++ gamingPackages;
}
