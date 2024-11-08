{ config, lib, pkgs, osConfig ? null, ... }:

# Graphical apps
# I only use Nix to manage graphical apps on NixOS and macOS.
# On other Linux, NixGL is required to make OpenGL and Vulkan work, and setting up the wrapping for that is more effort than I feel like putting in compared to just instaling those apps with flatpak.

let
  inherit (lib) optionals mkIf concatLists mkOption types;
  inherit (pkgs.hostPlatform) isx86_64 isLinux isDarwin;
  inherit (config.dotfiles) enableHomeGuiApps enableGaming enableLargeApps;

in {
  options.dotfiles = {
    enableHomeGuiApps = mkOption {
      type = types.bool;
      description = "Let Home Manager install graphical apps.";
      default = !config.targets.genericLinux.enable;
    };
    enableGaming = mkOption {
      type = types.bool;
      description = "Enable gaming-related packages.";
      default =
        if osConfig != null then osConfig.dotfiles.enableGaming
        else false;
    };
    enableLargeApps = mkOption {
      type = types.bool;
      description = "Enable large apps like the JetBrains tools or Electron";
      default = true;
    };
  };

  config.home.packages = with pkgs; mkIf enableHomeGuiApps (concatLists [
    [
      audacity
      qbittorrent
    ]

    (optionals enableLargeApps [
      vesktop # Discord client
      audacity
      qbittorrent

      # Dev programs
      jetbrains.clion
      jetbrains.idea-ultimate
      jetbrains.rust-rover
    ])

    (optionals (isLinux && enableLargeApps) [
      element-desktop
    ])

    (optionals isLinux [
      vlc
      mpv
      filezilla
      pinta

      # Broken with Darwin refactor, move this one back too when fixed!
      neovide
    ])

    (optionals (isLinux && isx86_64) [
      bitwarden-desktop
      cider # Apple Music
      jetbrains-toolbox
      zenmonitor
      via
    ])

    (optionals isDarwin [
      monitorcontrol
      utm
    ])

    (optionals enableGaming [
      prismlauncher # Minecraft

      # Emulators
      dolphin-emu-beta
      nanoboyadvance
      melonDS
    ])

    (optionals (enableGaming && isLinux) [
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
    ])
  ]);
}
