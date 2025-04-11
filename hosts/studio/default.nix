{ ... }:

{
  system.stateVersion = 5;

  dotfiles.builders.enable = true;

  home-manager.users.nhp = {
    home.stateVersion = "24.05";
    dotfiles.zshPromptColor = "green";
    dotfiles.enableGaming = true;
  };

  nix-rosetta-builder.enable = false;
}
