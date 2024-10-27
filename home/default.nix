{ lib, pkgs, config, ... }:

{
  # TODO find out if there's a better way to "inherit" an option

  config = let
    username = config.home.username;
    homePrefix = if pkgs.stdenv.isDarwin then "/Users/" else "/home/";
  in {
    programs.home-manager.enable = true;

    home.homeDirectory = homePrefix + username;

    home.sessionPath = [
      "/home/${username}/.local/bin"
    ];
  };

  imports = [
    ./zsh.nix
    ./packages.nix
    ./graphical-apps.nix
    ./git.nix
    ./neovim.nix
    ./firefox.nix
    ./openal-soft.nix
    ./appearance.nix
    ./vscode.nix
    ./development.nix
    ./darwin-apps.nix
  ];
}
