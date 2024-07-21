{ lib, pkgs, ... }:

let
  inherit (lib) optional;
  inherit (pkgs.hostPlatform) isx86_64 isAarch64 isLinux isDarwin;

  isMacOrx86_64 = isx86_64 || isDarwin;
  isx86Linux = isLinux && isx86_64;

  macOrx86_64Packages = with pkgs; optional isMacOrx86_64 [
    discord
    bitwarden-desktop
    cider # Apple Music

    jetbrains-toolbox
    jetbrains-clion

    # Swift language server. Technically available on ARM Linux but requires compiling Swift and that's slow.
    sourcekit-lsp
  ];

  linuxx86Packages = with pkgs; optional isx86Linux [
    zenmonitor
  ];

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
in {
  home.packages = commonPackages ++ macOrx86_64Packages ++ linuxx86Packages;

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
