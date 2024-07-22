{ config, lib, pkgs, ... }:

let
  inherit (lib) optionals;
  inherit (pkgs.hostPlatform) isx86_64 isLinux isDarwin;

  isMacOrx86_64 = isx86_64 || isDarwin;
  isx86Linux = isLinux && isx86_64;

  macOrx86_64Packages = optionals isMacOrx86_64 (with pkgs; [
    discord
    bitwarden-desktop
    cider # Apple Music

    jetbrains-toolbox
    jetbrains.clion

    # Swift language server. Technically available on ARM Linux but requires compiling Swift and that's slow.
    sourcekit-lsp
  ]);

  linuxx86Packages = optionals isx86Linux (with pkgs; [
    zenmonitor
  ]);

  commonPackages = with pkgs; [
    # Desktop programs
    mpv
    audacity
    furmark

    # Dev programs
    neovim-qt
    neovide

    # CLI utilities
    wl-clipboard
    fastfetch # you've gotta have a fetch program, right?
    gh
    ripgrep
    htop
    btop
    ncdu
    tmux
    usbutils
    pciutils
    unzip
    zip
    p7zip-rar
    distrobox

    # Nix stuff
    nixpkgs-fmt
    nix-search-cli
    comma

    # Dev CLI
    cmake
    ninja
    gdb
    lldb

    # Language servers and such
    lua-language-server # For neovim configuration
    clang-tools
    nixd
    cmake-language-server
    tree-sitter
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
in {
  home.packages = commonPackages
    ++ macOrx86_64Packages
    ++ linuxx86Packages
    ++ gamingPackages;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withNodeJs = true; # Needed for some plugins
    vimAlias = true;
    viAlias = true;
  };

  programs.git.lfs.enable = true;
  programs.nix-index.enable = true;
}
