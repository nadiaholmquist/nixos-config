{ lib, pkgs, osConfig ? null, ... }:

{
  # TODO find out if there's a better way to "inherit" an option
  options = let
    inherit (lib) mkOption types;
  in {
    dotfiles.enableGaming = mkOption {
      type = types.bool;
      description = "Enable gaming-related packages.";
      default =
        if osConfig != null then osConfig.dotfiles.enableGaming
        else false;
    };
  };

  config = let
    homeDir = if pkgs.stdenv.isDarwin then "/Users/nhp" else "/home/nhp";
  in {
    programs.home-manager.enable = true;

    home.username = "nhp";
    home.homeDirectory = homeDir;

    home.sessionPath = [
      "/home/nhp/.local/bin"
    ];

    programs.git = {
      enable = true;
      userName = "Nadia Holmquist Pedersen";
      userEmail = "nadia@nhp.sh";
      extraConfig = {
        url = {
          "ssh://git@github.com" = {
            insteadOf = "github";
          };
        };
      };
    };
  };

  imports = [
    ./zsh.nix
    ./packages.nix
    ./graphical-apps.nix
    ./firefox.nix
  ];
}
