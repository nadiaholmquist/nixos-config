{ config, lib, pkgs, ... }:

# Graphical apps
# I only use Nix to manage graphical apps on NixOS.
# The way Nix wants to symlink apps into Applications on macOS doesn't work in a way that I find particularly nice to use, so I just manage apps manually there.
# On other Linux, NixGL is required to make OpenGL and Vulkan work, and setting up the wrapping for that is more effort than I feel like putting in compared to just instaling those apps with flatpak.

let
  inherit (lib) optionals mkIf;
  inherit (pkgs.hostPlatform) isx86_64 isLinux isDarwin;

  x86_64Packages = optionals isx86_64 (with pkgs; [
    bitwarden-desktop
    cider # Apple Music
    jetbrains-toolbox
    zenmonitor
  ]);

  commonPackages = with pkgs; [
    vesktop # Discord client

    # Graphical apps
    mpv
    audacity
    vlc

    # Dev programs
    jetbrains.clion
    jetbrains.idea-ultimate
    jetbrains.rust-rover
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

  allPackages = commonPackages ++ x86_64Packages ++ gamingPackages;
in mkIf config.dotfiles.enableHomeGuiApps {
  home.packages = allPackages;
}
