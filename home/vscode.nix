{ pkgs, lib, ... }:

lib.mkIf pkgs.stdenv.isLinux {
  programs.vscode.enable = true;
  programs.vscode.extensions = with pkgs.vscode-extensions; [
    vscodevim.vim
    jnoortheen.nix-ide
    llvm-vs-code-extensions.vscode-clangd
    ms-vscode.cmake-tools
    catppuccin.catppuccin-vsc
  ];
}
