{ pkgs, lib, config, ... }:

lib.mkIf config.dotfiles.enableHomeGuiApps {
  programs.vscode.enable = true;
  programs.vscode.extensions = with pkgs.vscode-extensions; [
    vscodevim.vim
    jnoortheen.nix-ide
    llvm-vs-code-extensions.vscode-clangd
    ms-vscode.cmake-tools
    catppuccin.catppuccin-vsc
  ];
}
