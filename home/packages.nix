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
    tmux
    calc
    ncdu

    # Archives
    zip
    p7zip
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
    ninja
  ];

  macPackages = optionals isDarwin (with pkgs; [
    gnumake
    cmake
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
    stdenv.cc
    cmakeWithGui
    gdb
    lldb
  ]);
in {
  home.packages = commonPackages
    ++ macPackages
    ++ linuxx86Packages
    ++ linuxPackages;
}
