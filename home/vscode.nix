{
  pkgs,
  lib,
  config,
  ...
}:

lib.mkIf config.dotfiles.enableHomeGuiApps {
  programs.vscode.enable = true;
  programs.vscode.package = pkgs.vscode-fhsWithPackages (
    p: with p; [
      clang-tools
      nixd
      rust-analyzer
    ]
  );
}
