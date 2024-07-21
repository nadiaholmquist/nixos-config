{ pkgs, ... }:

{
  imports = [
    ./zsh.nix
    ./packages.nix
    ./firefox.nix
  ];

  programs.home-manager.enable = true;

  home.username = "nhp";
  home.homeDirectory = "/home/nhp";

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
}
