{ config, lib, pkgs, ... }:

# Graphical apps
# I only use Nix to manage graphical apps on NixOS.
# The way Nix wants to symlink apps into Applications on macOS doesn't work in a way that I find particularly nice to use, so I just manage apps manually there.
# On other Linux, NixGL is required to make OpenGL and Vulkan work, and setting up the wrapping for that is more effort than I feel like putting in compared to just instaling those apps with flatpak.

let
  inherit (lib) optionals mkIf;
  inherit (pkgs.hostPlatform) isx86_64 isLinux isDarwin;
  inherit (config.dotfiles) enableHomeGuiApps enableGaming;

  x86_64Packages = optionals isx86_64 (with pkgs; [
    bitwarden-desktop
    cider # Apple Music
    jetbrains-toolbox
    zenmonitor
  ]);

  linuxPackages = optionals isLinux (with pkgs; [
    vlc
    mpv
    filezilla
    pinta
    via
  ]);

  darwinPackages = optionals isDarwin (with pkgs; [
    iterm2
    monitorcontrol
    utm
  ]);

  commonPackages = with pkgs; [
    vesktop # Discord client
    element-desktop
    audacity
    qbittorrent

    # Dev programs
    jetbrains.clion
    jetbrains.idea-ultimate
    jetbrains.rust-rover
    neovide
  ];

  gamingPackages = optionals enableGaming (with pkgs; [
    prismlauncher # Minecraft

    # Emulators
    dolphin-emu-beta
    nanoboyadvance
    melonDS
  ]) ++ optionals (enableGaming && isLinux) (with pkgs; [
    cemu
    duckstation
    ares
    mgba
    (retroarch.override {
      cores = with libretro; [
        mesen bsnes snes9x genesis-plus-gx mupen64plus
      ];
    })
    pcsx2
    ryujinx
  ]);

  allPackages =
    commonPackages ++ linuxPackages ++ darwinPackages
    ++ x86_64Packages
    ++ gamingPackages;
in mkIf enableHomeGuiApps {
  home.packages = allPackages;
}
