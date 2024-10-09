{ pkgs, ... }:

{
  system.stateVersion = 5;

  home-manager.users.nhp = {
    home.stateVersion = "24.05";
    dotfiles.zshPromptColor = "green";
    dotfiles.enableGaming = true;
  };

  imports = [
    ./builders.nix
  ];
}
