{ config, lib, pkgs, ... }:

let
  inherit (lib) optionals;
  inherit (pkgs.hostPlatform) isx86_64 isLinux isDarwin;

  isx86Linux = isLinux && isx86_64;

  commonPackages = with pkgs; [
    # CLI utilities
    fastfetch # you've gotta have a fetch program, right?
    gh
    ripgrep
    htop
    btop
    ncdu
    tmux
    calc

    # Archives
    zip
    p7zip-rar
    unzip

    # Nix stuff
    nixpkgs-fmt
    nix-index
    nix-search-cli
    nix-tree
    nix-update
    nix-output-monitor
    nixos-rebuild
    comma
    deploy-rs

    # Dev CLI
    cmake
    ninja

    # Language servers and such
    lua-language-server # For neovim configuration
    clang-tools
    nixd
    cmake-language-server
    tree-sitter
  ];

  macPackages = optionals isDarwin (with pkgs; [
    gnumake
  ]);

  linuxx86Packages = optionals isx86Linux (with pkgs; [
    # Swift language server. Technically available on ARM Linux but requires compiling Swift and that's slow.
    #sourcekit-lsp
  ]);

  linuxPackages = optionals isLinux (with pkgs; [
    # CLI utilities
    wl-clipboard
    usbutils
    pciutils
    distrobox

    # Development
    gdb
    lldb
  ]);
in {
  home.packages = commonPackages
    ++ macPackages
    ++ linuxx86Packages
    ++ linuxPackages;
}
