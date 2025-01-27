{ lib, pkgs, ... }:

let
  inherit (lib) optionals concatLists;
  inherit (pkgs.hostPlatform) isx86_64 isLinux isDarwin;
in {
  home.packages = with pkgs; concatLists [
    [
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
      unrar
      gzip
      lz4
      xz
      zstd

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
    ]

    (optionals isDarwin [
      gnumake
      cmake
    ])

    (optionals (isLinux && isx86_64) [
      # Swift language server. Technically available on ARM Linux but requires compiling Swift and that's slow.
      #sourcekit-lsp
    ])

    (optionals isLinux [
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
    ])
  ];
}
