{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Desktop programs
    discord
    bitwarden-desktop
    mpv
    audacity
    cider # Apple Music
    furmark
    zenmonitor

    # Dev programs
    neovim-qt
    neovide
    jetbrains-toolbox
    jetbrains.clion

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
    sourcekit-lsp # Swift
    nixd
    cmake-language-server
    tree-sitter
  ];

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
