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
    optional
    optionals
    mkIf
    concatLists
    mkOption
    types
    ;
  inherit (pkgs.hostPlatform) isx86_64 isLinux isDarwin;
  inherit (config.dotfiles)
    enableGaming
    enableHomeGuiApps
    enableLargeApps
    enableJetBrains
    ;

  isx86_64Linux = isLinux && isx86_64;

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
    enableJetBrains = mkOption {
      type = types.bool;
      description = "Enable JetBrains IDEs (uses a lot of disk space)";
      default = config.dotfiles.enableLargeApps;
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

      (optionals isLinux [
        vlc
        mpv
        filezilla
        pinta
      ])

      (optionals (isLinux && isx86_64) [
        cider # Apple Music
        zenmonitor
        via
      ])

      (optionals isDarwin [
        mpv-unwrapped # wrapped `mpv` has a broken app bundle
        utm
        qemu
      ])

      (optionals enableJetBrains [
        # Dev programs
        jetbrains.clion
        jetbrains.idea-ultimate
        jetbrains.rust-rover
      ])

      (optional (isx86_64Linux && enableJetBrains) jetbrains-toolbox)

      (optionals (isLinux && enableLargeApps) [
        bitwarden-desktop
        element-desktop
        # The official Discord client only supports x86_64 on Linux
        (if isx86_64 then discord else vesktop)
      ])

      (optionals enableGaming [
        prismlauncher # Minecraft
        gzdoom

        # Emulators
        ares
        nanoboyadvance
        melonDS
      ])

      (optionals (enableGaming && isLinux) [
        # Emulators
        cemu
        dolphin-emu-beta
        duckstation
        mgba
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
