{ lib, pkgs, config, osConfig ? null, ... }:

{
  # TODO find out if there's a better way to "inherit" an option
  options.dotfiles = let
    inherit (lib) mkOption types;
  in {
    enableGaming = mkOption {
      type = types.bool;
      description = "Enable gaming-related packages.";
      default =
        if osConfig != null then osConfig.dotfiles.enableGaming
        else false;
    };
    enableHomeGuiApps = mkOption {
      type = types.bool;
      description = "Let Home Manager install graphical apps.";
      default = !(config.targets.genericLinux.enable || pkgs.stdenv.isDarwin);
    };
  };

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
  ];
}
