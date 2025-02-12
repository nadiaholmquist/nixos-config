{
  config,
  lib,
  pkgs,
  osConfig ? null,
  ...
}:

# Graphical apps
# I only use Nix to manage graphical apps on NixOS and macOS.
# On other Linux, NixGL is required to make OpenGL and Vulkan work, and setting up the wrapping for that is more effort than I feel like putting in compared to just instaling those apps with flatpak.

let
  inherit (lib)
    optionals
    mkIf
    concatLists
    mkOption
    types
    ;
  inherit (pkgs.hostPlatform) isx86_64 isLinux isDarwin;
  inherit (config.dotfiles) enableHomeGuiApps enableGaming enableLargeApps;

in
{
  options.dotfiles = {
    enableHomeGuiApps = mkOption {
      type = types.bool;
      description = "Let Home Manager install graphical apps.";
      default = !config.targets.genericLinux.enable;
    };
    enableGaming = mkOption {
      type = types.bool;
      description = "Enable gaming-related packages.";
      default = if osConfig != null then osConfig.dotfiles.enableGaming else false;
    };
    enableLargeApps = mkOption {
      type = types.bool;
      description = "Enable large apps like the JetBrains tools or Electron";
      default = true;
    };
  };

  config.home.packages =
    with pkgs;
    mkIf enableHomeGuiApps (concatLists [
      [
        audacity
        qbittorrent
        neovide
      ]

      (optionals enableLargeApps [
        # Dev programs
        jetbrains.clion
        jetbrains.idea-ultimate
        jetbrains.rust-rover
      ])

      (optionals (isLinux && enableLargeApps) [
        discord
        element-desktop
      ])

      (optionals isLinux [
        vlc
        mpv
        filezilla
        pinta
      ])

      (optionals (isLinux && isx86_64) [
        bitwarden-desktop
        cider # Apple Music
        jetbrains-toolbox
        zenmonitor
        via
      ])

      (optionals isDarwin [
        mpv-unwrapped # wrapped `mpv` has a broken app bundle
        utm
        qemu
      ])

      (optionals enableGaming [
        prismlauncher # Minecraft

        # Emulators
        dolphin-emu-beta
        nanoboyadvance
        melonDS
      ])

      (optionals (enableGaming && isLinux) [
        gzdoom

        # Emulators
        cemu
        duckstation
        ares
        mgba
        lime3ds
        (retroarch.withCores (
          l: with l; [
            mesen
            bsnes
            snes9x
            genesis-plus-gx
            mupen64plus
          ]
        ))
        pcsx2
        ppsspp
        ryujinx
      ])
    ]);
}
