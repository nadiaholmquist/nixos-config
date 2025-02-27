{
  pkgs,
  config,
  ...
}:

{
  programs.vscode = {
    enable = config.dotfiles.enableHomeGuiApps && config.dotfiles.enableLargeApps;
    mutableExtensionsDir = true;

    package =
      if pkgs.stdenv.hostPlatform.isDarwin then
        pkgs.vscode
      else
        pkgs.vscode-fhsWithPackages (
          p: with p; [
            clang-tools
            nixd
            rust-analyzer
          ]
        );
  };
}
