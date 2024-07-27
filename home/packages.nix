{ config, lib, pkgs, ... }:

let
  inherit (lib) optionals;
  inherit (pkgs.hostPlatform) isx86_64 isLinux isDarwin;

  isx86Linux = isLinux && isx86_64;

  macPackages = optionals isDarwin (with pkgs; [

  ]);

  linuxx86Packages = optionals isx86Linux (with pkgs; [
    # Swift language server. Technically available on ARM Linux but requires compiling Swift and that's slow.
    sourcekit-lsp
  ]);

  linuxPackages = optionals isLinux (with pkgs; [
    # CLI utilities
    wl-clipboard
    usbutils
    pciutils
    distrobox
    
    # Archives
    zip
    p7zip
    unzip

    # Development
    gdb
    lldb
  ]);

  commonPackages = with pkgs; [
    # CLI utilities
    fastfetch # you've gotta have a fetch program, right?
    gh
    ripgrep
    htop
    btop
    ncdu
    tmux

    # Nix stuff
    nixpkgs-fmt
    nix-search-cli
    comma

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
in {
  home.packages = commonPackages
    ++ macPackages
    ++ linuxx86Packages
    ++ linuxPackages;

  programs.neovim = {
    enable = true;
    #package = pkgs.pkgsUnstable.neovim-unwrapped;
    defaultEditor = true;
    withNodeJs = true; # Needed for some plugins
    withPython3 = true;
    vimAlias = true;
    viAlias = true;
  };

  programs.git.lfs.enable = true;
  programs.nix-index.enable = true;
}
